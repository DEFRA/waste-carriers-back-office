# frozen_string_literal: true

require_relative "../timed_service_runner"
MINUTE_IN_SECONDS = 60.0
MAX_REQUESTS_PER_MINUTE = 600

namespace :lookups do
  namespace :update do

    desc "Update all sites with a missing area (postcode must be populated)"
    task missing_ea_areas: :environment do
      next unless WasteCarriersEngine::FeatureToggle.active?(:run_ea_areas_job)

      run_service(ea_area_match_clause, Address::UpdateEaAreaService)
    end

    desc "Update all sites with a missing easting or northing (postcode must be populated)"
    task missing_easting_northings: :environment do
      next unless WasteCarriersEngine::FeatureToggle.active?(:run_ea_areas_job)

      run_service(easting_northing_match_clause, Address::UpdateEastingNorthingService)
    end
  end
end

def run_service(address_match_clause, service)
  run_for = WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i
  address_limit = WasteCarriersBackOffice::Application.config.lookups_update_address_limit.to_i

  registrations_scope = WasteCarriersEngine::Registration.collection.aggregate(
    scope_pipeline(address_limit, address_match_clause)
  ).pluck(:_id)

  throttle = MINUTE_IN_SECONDS / MAX_REQUESTS_PER_MINUTE

  TimedServiceRunner.run(
    scope: registrations_scope,
    run_for: run_for,
    service:,
    throttle: throttle
  )
end

def scope_pipeline(address_limit, address_match_clause)
  [
    # Include active registrations with a registered address
    { "$match": { "metaData.status": "ACTIVE", "addresses.addressType": "REGISTERED" } },
    #  Unwind to one document per address element...
    { "$unwind": "$addresses" },
    #  ... and include only registered addresses without an area and with a postcode
    { "$match": {
      "$and": [
        "addresses.addressType": "REGISTERED",
        "addresses.postcode": { "$nin": [nil, ""] }
        # ... and blend in the detailed address match clause for this task
      ] + [address_match_clause]
    } },
    { "$limit": address_limit },
    # we need only the registration ids
    { "$project": { _id: 1 } }
  ]
end

def ea_area_match_clause
  {
    "addresses.area": { "$in": [nil, ""] }
  }
end

def easting_northing_match_clause
  {
    "$or": [
      { "addresses.easting": nil },
      { "addresses.northing": nil }
    ]
  }
end
