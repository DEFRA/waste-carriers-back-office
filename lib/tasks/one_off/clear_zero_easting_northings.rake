# frozen_string_literal: true

namespace :one_off do
  desc "Clear zeroed eastings and northings to allow them to be looked up again"
  task clear_zero_easting_northings: :environment do

    # addresses are embedded in registrations, so need to first find qualifying registrations, then impacted addresses
    registrations = WasteCarriersEngine::Registration.or(
      { "addresses.easting": 0 },
      { "addresses.northing": 0 }
    )

    puts "Clearing zeroed coordinates for #{registrations.count} registrations" unless Rails.env.test?

    registrations.each do |registration|
      registration.addresses.select { |address| address.easting&.zero? || address.northing&.zero? }
                            .map { |address| address.update(easting: nil, northing: nil) }
    end
  end
end
