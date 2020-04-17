# frozen_string_literal: true

class RenewalReminderMailer < ActionMailer::Base
  helper "waste_carriers_engine/mailer"

  def first_reminder_email(registration)
    @registration = registration

    mail(
      to: collect_addresses(registration),
      from: "#{Rails.configuration.email_service_name} <#{Rails.configuration.email_service_email}>",
      subject: I18n.t(".renewal_reminder_mailer.first_reminder_email.subject", date: @expiry_date)
    )
  end

  private

  def collect_addresses(registration)
    [registration.contact_email, registration.account_email].compact.uniq
  end
end
