# frozen_string_literal: true

require_relative "../timed_service_runner"

namespace :lookups do
  namespace :update do
    desc "Update all sites with a missing area (postcode must be populated)"
    task missing_area: :environment do
      run_for = WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i
      address_limit = WasteCarriersBackOffice::Application.config.area_lookup_address_limit.to_i
      addresses_scope = WasteCarriersEngine::Address.missing_area.with_postcode.limit(address_limit)

      TimedServiceRunner.run(
        scope: addresses_scope,
        run_for: run_for,
        service: WasteCarriersEngine::AssignSiteDetailsService
      )
    end
  end
end
