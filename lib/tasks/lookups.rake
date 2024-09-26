# frozen_string_literal: true

require_relative "../timed_service_runner"
MINUTE_IN_SECONDS = 60.0
MAX_REQUESTS_PER_MINUTE = 600

namespace :lookups do
  namespace :update do

    desc "Update all sites with a missing area (postcode must be populated)"
    task missing_address_attributes: :environment do
      return false unless WasteCarriersEngine::FeatureToggle.active?(:run_ea_areas_job)

      run_for = WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i
      address_limit = WasteCarriersBackOffice::Application.config.area_lookup_address_limit.to_i

      registrations_scope = WasteCarriersEngine::Registration.collection.aggregate(pipeline(address_limit)).pluck(:_id)

      throttle = MINUTE_IN_SECONDS / MAX_REQUESTS_PER_MINUTE

      TimedServiceRunner.run(
        scope: registrations_scope,
        run_for: run_for,
        service: WasteCarriersEngine::UpdateAddressDetailsFromOsPlacesService,
        throttle: throttle
      )
    end
  end
end

def pipeline(address_limit)
  [
    # Include active registrations with a registered address
    { "$match": { "metaData.status": "ACTIVE", "addresses.addressType": "REGISTERED" } },
    #  Unwind to one document per address element...
    { "$unwind": "$addresses" },
    #  ... and include only registered addresses without an area and with a postcode
    { "$match": {
      "$and": [
        "addresses.addressType": "REGISTERED",
        "addresses.postcode": { "$nin": [nil, ""] },
        "$or": [
          { "addresses.area": { "$in": [nil, ""] } },
          { "addresses.easting": nil },
          { "addresses.northing": nil }
        ]
      ]
    } },
    { "$limit": address_limit },
    # we need only the registration ids
    { "$project": { _id: 1 } }
  ]
end
