# frozen_string_literal: true

class SecondRenewalReminderService < RenewalReminderServiceBase
  private

  def send_email(registration)
    RenewalReminderMailer.second_reminder_email(registration).deliver_now
  end

  def expires_in_days
    Rails.configuration.second_renewal_email_reminder_days.to_i
  end
end
