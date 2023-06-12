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
  def self.run(scope:, run_for:, service:, throttle: 0)
    run_until = run_for.minutes.from_now

    scope.each do |registration_id|
      break if Time.zone.now > run_until

      begin
        service.run(registration_id: registration_id)
      rescue StandardError => e
        handle_error(e, registration_id, service)
      end
      sleep(throttle) if throttle.positive?
    end
  end

  def self.handle_error(error, registration_id, service)
    Airbrake.notify(error, registration_id: registration_id)
    Rails.logger.error "#{service.name.demodulize} failed:\n #{error}"
  end
end
