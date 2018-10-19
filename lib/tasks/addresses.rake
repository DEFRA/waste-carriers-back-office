# frozen_string_literal: true

require "rest-client"

namespace :address do
  desc "Fix addresses in renewed registrations set during renewals process to match old data format"
  task update_renewed_regs_from_os_places: :environment do
    update_addresses_for_registrations
  end

  desc "Fix addresses in transient registrations set during renewals process to match old data format"
  task update_transient_regs_from_os_places: :environment do
    update_addresses_for_transient_registrations
  end
end

def update_addresses_for_registrations
  counts = {
    total: 0,
    corrected: 0,
    error: 0
  }
  counts[:total] = renewed_registrations.count

  paging = {
    page_size: 100,
    page_number: 1,
    num_of_pages: (counts[:total] / 100.to_f).ceil
  }

  print "Finding all renewed registrations..."
  puts " #{counts[:total]} matching registrations found.\n\n"

  counts = page_through_registrations(paging, counts)

  puts "\nChecking #{counts[:total]} registrations for possible corrections"
  puts "Errors: #{counts[:error]}"
  puts "Corrections: #{counts[:corrected]}"
end

def update_addresses_for_transient_registrations
  counts = {
    total: 0,
    corrected: 0,
    error: 0
  }
  counts[:total] = transient_registrations.count

  paging = {
    page_size: 100,
    page_number: 1,
    num_of_pages: (counts[:total] / 100.to_f).ceil
  }

  print "Finding all transient registrations..."
  puts " #{counts[:total]} matching transient registrations found.\n\n"

  counts = page_through_transient_registrations(paging, counts)

  puts "\nChecking #{counts[:total]} transient registrations for possible corrections"
  puts "Errors: #{counts[:error]}"
  puts "Corrections: #{counts[:corrected]}"
end

def registrations_collection
  Mongoid::Clients.default.database.collections.find { |c| c.name == "registrations" }
end

def transient_registrations_collection
  Mongoid::Clients.default.database.collections.find { |c| c.name == "transient_registrations" }
end

def paged_renewed_registrations(paging)
  registrations_collection
    .find(past_registrations: { "$exists": true })
    .skip(paging[:page_size] * (paging[:page_number] - 1))
    .limit(paging[:page_size])
end

def paged_transient_registrations(paging)
  transient_registrations_collection
    .find(addresses: { "$exists": true })
    .skip(paging[:page_size] * (paging[:page_number] - 1))
    .limit(paging[:page_size])
end

def renewed_registrations
  registrations_collection.find(past_registrations: { "$exists": true }).no_cursor_timeout
end

def transient_registrations
  transient_registrations_collection.find(addresses: { "$exists": true }).no_cursor_timeout
end

def page_through_registrations(paging, counts)
  while paging[:page_number] <= paging[:num_of_pages]
    klass = WasteCarriersEngine::Registration
    counts = update_addresses_for(paged_renewed_registrations(paging), klass, counts)
    paging[:page_number] += 1
  end
  counts
end

def page_through_transient_registrations(paging, counts)
  while paging[:page_number] <= paging[:num_of_pages]
    klass = WasteCarriersEngine::TransientRegistration
    counts = update_addresses_for(paged_transient_registrations(paging), klass, counts)
    paging[:page_number] += 1
  end
  counts
end

# rubocop:disable Metrics/LineLength
def update_addresses_for(results, klass, counts)
  results.each do |result|
    begin
      registration = klass.find(result["_id"])
      reg_addr_corrected = update_address(registration.registered_address) if address_is_from_os_places?(registration.registered_address)
      cnt_addr_corrected = update_address(registration.contact_address) if address_is_from_os_places?(registration.contact_address)
      counts[:corrected] += 1 if reg_addr_corrected || cnt_addr_corrected
    rescue StandardError => e
      puts " ERROR"
      counts[:error] += 1

      puts "\n----------"
      puts "#{registration.reg_identifier} - attempt to correct addresses failed"
      puts e.to_s
    end
  end

  counts
end
# rubocop:enable Metrics/LineLength

def address_is_from_os_places?(address)
  address.present? && address.address_mode == "address-results"
end

def update_address(old_address)
  new_address = build_updated_address(old_address)
  return false if new_address.blank? || address_is_the_same?(old_address, new_address)

  replace_old_address(old_address, new_address)
  true
end

def build_updated_address(old_address)
  matching_address = search_by_uprn(old_address.uprn)

  if matching_address.blank?
    parent = old_address._parent
    puts "Could not update #{old_address.address_type} address for #{parent.class} #{parent.reg_identifier}"\
         " - no matching address found for UPRN #{old_address.uprn}"
    return nil
  end

  # Create new address
  new_address = WasteCarriersEngine::Address.create_from_os_places_data(matching_address)
  new_address.address_type = old_address.address_type
  new_address.first_name = old_address.first_name if old_address.first_name.present?
  new_address.last_name = old_address.last_name if old_address.last_name.present?

  new_address
end

def search_by_uprn(uprn)
  url = "#{Rails.configuration.os_places_service_url}/addresses/#{uprn}"

  begin
    response = RestClient::Request.execute(method: :get, url: url)

    begin
      JSON.parse(response)
    rescue JSON::ParserError => e
      Rails.logger.error "OS Places JSON error: " + e.to_s
      nil
    end
  rescue RestClient::BadRequest
    Rails.logger.debug "OS Places: resource not found"
    nil
  rescue RestClient::ExceptionWithResponse => e
    Rails.logger.error "OS Places response error: " + e.to_s
    nil
  rescue SocketError => e
    Rails.logger.error "OS Places socket error: " + e.to_s
    nil
  end
end

def replace_old_address(old_address, new_address)
  parent = old_address._parent

  # Update the transient object's nested addresses, replacing any existing address of the same type
  updated_addresses = parent.addresses
  updated_addresses.delete(old_address)
  updated_addresses << new_address
  parent.addresses = updated_addresses

  log_address_change(old_address, new_address, parent)

  parent.save!
end

def log_address_change(old_address, new_address, parent)
  puts "Updated #{old_address.address_type} address for #{parent.class} #{parent.reg_identifier}"

  puts "OLD: #{old_address.attributes.to_json}"
  puts "NEW: #{new_address.attributes.to_json}"
  puts "\n"
end

def address_is_the_same?(old_address, new_address)
  old_address_data = old_address.attributes.except("_id")
  new_address_data = new_address.attributes.except("_id")

  old_address_data == new_address_data
end
