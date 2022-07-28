# frozen_string_literal: true

module CanResendEmail
  extend ActiveSupport::Concern

  private

  def validate_contact_email(registration)
    # checks that the email is present
    # can raise: MissingContactEmailError
    ContactEmailValidatorService.run(registration)
  end

  # If the registration has a missing contact_email we know
  # RenewalReminderMailer will throw a MissingContactEmailError. There is not
  # really anything we can do and the reason for the missing field is legacy
  # issues. So we don't worry about Airbrake or adding anything to the log.
  def handle_missing_contact_email(scope)
    message = I18n.t("#{scope}.messages.missing.heading")
    description = I18n.t("#{scope}.messages.missing.details")

    flash_error(message, description)
  end

  # Here we notify Airbrake and log an error. If we get here it's for an
  # unexpected reason hence we want to know about it.
  def handle_resend_errored(error, scope, applies_to)
    Airbrake.notify error, registration: registration.reg_identifier
    Rails.logger.error "Error #{applies_to} for registration #{registration.reg_identifier}"

    message = I18n.t("#{scope}.messages.error.heading", email: registration.contact_email)
    description = I18n.t("#{scope}.messages.error.details")

    flash_error(message, description)
  end
end
