# frozen_string_literal: true

require_relative "../timed_service_runner"

namespace :lookups do
  namespace :update do
    desc "Update all sites with a missing area (postcode must be populated)"
    task missing_area: :environment do
      run_for = WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i
      address_limit = WasteCarriersBackOffice::Application.config.area_lookup_address_limit.to_i
      counter = 0
      addresses_scope = []

      WasteCarriersEngine::Registration.where("address.area": nil).each do |registration|
        break if counter >= address_limit

        missing_area_addresses = registration.addresses.missing_area.with_postcode
        missing_area_count = missing_area_addresses.count
        counter += missing_area_count

        # Limit the number of addresses added if the counter goes over the limit
        missing_area_count -= (counter - address_limit) if counter > address_limit

        addresses_scope.concat(missing_area_addresses.limit(missing_area_count))
      end

      addresses_scope = addresses_scope.take(address_limit) if addresses_scope.count > address_limit

      TimedServiceRunner.run(
        scope: addresses_scope,
        run_for: run_for,
        service: WasteCarriersEngine::AssignSiteDetailsService
      )
    end
  end
end
