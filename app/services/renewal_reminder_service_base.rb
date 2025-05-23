# frozen_string_literal: true

class RenewalReminderServiceBase < WasteCarriersEngine::BaseService
  def run
    expiring_registrations.each do |registration|
      send_email(registration)
    rescue StandardError => e
      Airbrake.notify e, registration: registration.reg_identifier
      Rails.logger.error "Failed to send first renewal email for registration #{registration.reg_identifier}"
    end

    expiring_registrations.size
  end

  private

  def send_email(registration)
    Notify::RenewalReminderEmailService.run(registration: registration)
  rescue StandardError => e
    Airbrake.notify(e, registration_no: registration.reg_identifier) if defined?(Airbrake)
  end

  def expiring_registrations
    WasteCarriersEngine::Registration
      .active
      .upper_tier
      .where(
        expires_on:
        {
          :$lte => expires_in_days.days.from_now.end_of_day,
          :$gte => expires_in_days.days.from_now.beginning_of_day
        }
      )
      .not_in(contact_email: [nil, ""])
      .communications_accepted
  end

  def expires_in_days
    raise(NotImplementedError)
  end
end
