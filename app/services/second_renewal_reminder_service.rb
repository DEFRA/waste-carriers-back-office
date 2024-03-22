# frozen_string_literal: true

class SecondRenewalReminderService < RenewalReminderServiceBase
  private

  def expires_in_days
    Rails.configuration.second_renewal_email_reminder_days.to_i
  end
end
