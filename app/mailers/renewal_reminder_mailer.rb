# frozen_string_literal: true

class RenewalReminderMailer < ActionMailer::Base
  helper "waste_carriers_engine/mailer"

  def first_reminder_email(registration)
    reminder_email(registration)
  end

  def second_reminder_email(registration)
    reminder_email(registration)
  end

  private

  def reminder_email(registration)
    raise Exceptions::MissingContactEmailError, registration.reg_identifier unless registration.contact_email.present?

    @registration = registration
    subject = I18n.t(
      ".renewal_reminder_mailer.first_reminder_email.subject",
      reg_identifier: registration.reg_identifier
    )
    @renew_link = RenewalMagicLinkService.run(token: registration.renew_token)

    mail(
      to: registration.contact_email,
      from: "#{Rails.configuration.email_service_name} <#{Rails.configuration.email_service_email}>",
      subject: subject,
      template_name: :first_reminder_email
    )
  end
end
