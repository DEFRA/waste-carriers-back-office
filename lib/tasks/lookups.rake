# frozen_string_literal: true

require_relative "../timed_service_runner"
MINUTE_IN_SECONDS = 60.0
MAX_REQUESTS_PER_MINUTE = 600

namespace :lookups do # rubocop:disable Metrics/BlockLength
  namespace :update do # rubocop:disable Metrics/BlockLength
    desc "Update all sites with a missing area (postcode must be populated)"

    task missing_area: :environment do
      run_for = WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i
      address_limit = WasteCarriersBackOffice::Application.config.area_lookup_address_limit.to_i

      address_docs = WasteCarriersEngine::Registration.collection.aggregate(pipeline(address_limit))

      # AssignSiteDetailsService expects an array of address objects, not BSON documents
      addresses_scope = address_docs.map { |address_doc| WasteCarriersEngine::Address.new(address_doc.except("_id")) }

      throttle = MINUTE_IN_SECONDS / MAX_REQUESTS_PER_MINUTE

      TimedServiceRunner.run(
        scope: addresses_scope,
        run_for: run_for,
        service: WasteCarriersEngine::AssignSiteDetailsService,
        throttle: throttle
      )
    end

    def pipeline(address_limit)
      [
        # Include active registrations with a registered address
        { "$match": { "metaData.status": "ACTIVE", "addresses.addressType": "REGISTERED" } },
        #  Unwind to one document per address element...
        { "$unwind": "$addresses" },
        #  ... and include only registered addresses without an area and with a postcode
        { "$match": {
          "addresses.addressType": "REGISTERED",
          "addresses.area": nil,
          "addresses.postcode": { "$nin": [nil, ""] }
        } },
        { "$limit": address_limit },
        #  flatten the results to return an array of address documents
        { "$replaceRoot": { newRoot: "$addresses" } }
      ]
    end
  end
end
