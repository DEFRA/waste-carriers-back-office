# frozen_string_literal: true

namespace :address do
  desc "Fix addresses set in the renewals process to match old data format"
  task update_from_os_places: :environment do
    registrations = WasteCarriersEngine::Registration.where(:past_registration.exists => true)
    transient_registrations = WasteCarriersEngine::TransientRegistration.where(:addresses.exists => true)

    update_addresses_for(registrations)
    update_addresses_for(transient_registrations)
  end
end

def update_addresses_for(registrations)
  registrations.each do |registration|
    update_address (registration.registered_address) if address_is_from_os_places?(registration.registered_address)
    update_address (registration.contact_address) if address_is_from_os_places?(registration.contact_address)
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
  # Send request to OS Places
  address_results = WasteCarriersEngine::AddressFinderService.new(old_address.postcode).search_by_postcode

  # Find the correct match - use UPRN :)
  matching_address = address_results.find { |result| result["uprn"] == old_address.uprn.to_s }

  if matching_address.blank?
    parent = old_address._parent
    puts "Could not update #{old_address.address_type} address for #{parent.class} #{parent.reg_identifier}"\
         " - no matching address found for UPRN #{old_address.uprn}"
    return nil
  end

  # Create new address
  new_address = WasteCarriersEngine::Address.create_from_os_places_data(matching_address)
  new_address.address_type = old_address.address_type

  new_address
end

def replace_old_address(old_address, new_address)
  parent = old_address._parent

  # Update the transient object's nested addresses, replacing any existing address of the same type
  updated_addresses = parent.addresses
  updated_addresses.delete(old_address)
  updated_addresses << new_address
  parent.addresses = updated_addresses

  puts "Updating #{old_address.address_type} address for #{parent.class} #{parent.reg_identifier}"
  parent.save!
end
