# frozen_string_literal: true

namespace :one_off do
  desc "Clear all 'Not found' areas to allow them to be looked up again"
  task clear_area_not_found_values: :environment do

    # addresses are embedded in registrations, so need to first find qualifying registrations, then impacted addresses
    registrations = WasteCarriersEngine::Registration.where("addresses.area": "Not found")

    puts "Updating 'Not found' areas for #{registrations.count} registrations" unless Rails.env.test?

    registrations.each do |registration|
      registration.addresses.select { |address| address.area == "Not found" }
                  .map { |address| address.update(area: nil) }
    end
  end
end
