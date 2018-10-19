# frozen_string_literal: true

require "rest-client"

namespace :address do
  desc "Fix addresses set in the renewals process to match old data format"
  task update_from_os_places: :environment do
    update_addresses_for_registrations
    update_addresses_for_transient_registrations
  end
end

def update_addresses_for_registrations
  registrations = WasteCarriersEngine::Registration.where(:past_registrations.exists => true)
  update_addresses_for(registrations)
end

def update_addresses_for_transient_registrations
  transient_registrations = WasteCarriersEngine::TransientRegistration.where(:addresses.exists => true)
  update_addresses_for(transient_registrations)
end

def update_addresses_for(registrations)
  registrations.each do |registration|
    update_address(registration.registered_address) if address_is_from_os_places?(registration.registered_address)
    update_address(registration.contact_address) if address_is_from_os_places?(registration.contact_address)
  end
end

def address_is_from_os_places?(address)
  address.present? && address.address_mode == "address-results"
end

def update_address(old_address)
  new_address = build_updated_address(old_address)
  return unless new_address

  replace_old_address(old_address, new_address)
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
  old_address_data = old_address.attributes.except("_id")
  new_address_data = new_address.attributes.except("_id")

  print "Checked #{old_address.address_type} address for #{parent.class} #{parent.reg_identifier}..."

  if old_address_data == new_address_data
    puts " No change"
  else
    puts " Address modified"
    puts "OLD: #{old_address_data.to_json}"
    puts "NEW: #{new_address_data.to_json}"
    puts "\n"
  end
end
