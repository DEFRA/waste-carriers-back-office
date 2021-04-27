# frozen_string_literal: true

class SecondRenewalReminderService < RenewalReminderServiceBase
  private

  def send_email(registration)
    Notify::RenewalReminderEmailService.run(registration: registration)
  rescue StandardError => e
    Airbrake.notify(e, registration_no: registration.reg_identifier) if defined?(Airbrake)
  end

  def expires_in_days
    Rails.configuration.second_renewal_email_reminder_days.to_i
  end
end
