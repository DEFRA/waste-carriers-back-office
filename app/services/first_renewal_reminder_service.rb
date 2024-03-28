# frozen_string_literal: true

class FirstRenewalReminderService < RenewalReminderServiceBase
  private

  def expires_in_days
    Rails.configuration.first_renewal_email_reminder_days.to_i
  end
end
