# frozen_string_literal: true

# Use in conjunction with long running tasks which you need to be throttled to
# only run for a certain length of time.
#
# For example rake task lookups:update:missing_area first finds then updates
# all site addresses missing an area. To ensure this does not run for too long
# we use +TimedServiceRunner+ to limit how long it runs for.
#
#     run_for = 60 # minutes
#     job_scope = WasteCarriersEngine::Address.site.missing_area.with_easting_and_northing
#     service_to_run = WasteCarriersEngine::AssignSiteDetailsService
#
#     TimedServiceRunner.run(
#       scope: job_scope,
#       run_for: run_for,
#       service: service_to_run
#     )
#
class TimedServiceRunner
  def self.run(scope:, run_for:, service:)
    run_until = run_for.minutes.from_now

    Rails.logger.debug { "#{Time.zone.now}: TimedServiceRunner started running" }

    scope.each do |address|
      break if Time.zone.now > run_until

      Rails.logger.debug { "#{Time.zone.now}: About to run service for address: #{address.id}" }

      begin
        service.run(address: address)
        Rails.logger.debug { "#{Time.zone.now}: Service ran successfully, about to save address" }
        address.save!
        Rails.logger.debug { "#{Time.zone.now}: Address saved successfully" }
      rescue StandardError => e
        handle_error(e, address.id)
      end
    end

    Rails.logger.debug { "#{Time.zone.now}: TimedServiceRunner finished running" }
  end

  def handle_error(error, address_id)
    Airbrake.notify(error, address_id: address_id)
    Rails.logger.error "#{service.name.demodulize} failed:\n #{error}"
  end
end
