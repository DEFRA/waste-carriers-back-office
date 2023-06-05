# frozen_string_literal: true

require_relative "../timed_service_runner"
MINUTE_IN_SECONDS = 60.0
MAX_REQUESTS_PER_MINUTE = 600

namespace :lookups do
  namespace :update do
    desc "Update all sites with a missing area (postcode must be populated)"

    task missing_area: :environment do
      run_for = WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i
      address_limit = WasteCarriersBackOffice::Application.config.area_lookup_address_limit.to_i
      counter = 0
      addresses_scope = []

      WasteCarriersEngine::Registration.active.where("address.area": nil).each do |registration|
        break if counter >= address_limit

        address = registration.company_address
        next if address.blank? || address.postcode.blank? || address.area.present?

        counter += 1

        addresses_scope.push(address)
      end

      addresses_scope = addresses_scope.take(address_limit) if addresses_scope.count > address_limit

      throttle = MINUTE_IN_SECONDS / MAX_REQUESTS_PER_MINUTE

      TimedServiceRunner.run(
        scope: addresses_scope,
        run_for: run_for,
        service: WasteCarriersEngine::AssignSiteDetailsService,
        throttle: throttle
      )
    end
  end
end
