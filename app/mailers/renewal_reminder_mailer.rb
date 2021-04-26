# frozen_string_literal: true

class RenewalReminderMailer < ActionMailer::Base
  helper "waste_carriers_engine/mailer"

  # The first reminder email has migrated to the RenewalReminderEmailService

  def second_reminder_email(registration)
    reminder_email(registration)
  end

  private

  def reminder_email(registration)
    validate_contact_email(registration)

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

  def validate_contact_email(registration)
    raise Exceptions::MissingContactEmailError, registration.reg_identifier unless registration.contact_email.present?

    assisted_digital_match = registration.contact_email == WasteCarriersEngine.configuration.assisted_digital_email

    raise Exceptions::AssistedDigitalContactEmailError, registration.reg_identifier if assisted_digital_match
  end
end
