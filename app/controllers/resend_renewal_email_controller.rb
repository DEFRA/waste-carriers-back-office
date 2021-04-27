# frozen_string_literal: true

class ResendRenewalEmailController < ApplicationController
  include CanSetFlashMessages

  before_action :authenticate_user!

  def new
    begin
      Notify::RenewalReminderEmailService.run(registration: registration)

      flash_success(
        I18n.t("resend_renewal_email.messages.success", email: registration.contact_email)
      )
    rescue Exceptions::MissingContactEmailError
      handle_missing_contact_email
    rescue Exceptions::AssistedDigitalContactEmailError
      handle_assisted_digital_contact_email
    rescue StandardError => e
      handle_resend_errored(e)
    end

    redirect_back(fallback_location: "/")
  end

  private

  def authenticate_user!
    authorize! :renew, WasteCarriersEngine::Registration
  end

  def registration
    @_registration ||= WasteCarriersEngine::Registration.find_by(reg_identifier: params[:reg_identifier])
  end

  # If the registration has a missing contact_email we know
  # RenewalReminderMailer will throw a MissingContactEmailError. There is not
  # really anything we can do and the reason for the missing field is legacy
  # issues. So we don't worry about Airbrake or adding anything to the log.
  def handle_missing_contact_email
    message = I18n.t("resend_renewal_email.messages.missing.heading")
    description = I18n.t("resend_renewal_email.messages.missing.details")

    flash_error(message, description)
  end

  # If the registration has a contact_email that matches the configured assisted
  # digital one we know RenewalReminderMailer will throw a
  # AssistedDigitalContactEmailError. This isn't something we want to record. So
  # we don't worry about Airbrake or adding anything to the log.
  def handle_assisted_digital_contact_email
    message = I18n.t("resend_renewal_email.messages.assisted.heading")
    description = I18n.t(
      "resend_renewal_email.messages.assisted.details",
      email: WasteCarriersEngine.configuration.assisted_digital_email
    )

    flash_error(message, description)
  end

  # Here we do notify Airbrake and log an error. If we get here it's for an
  # unexpected reason hence we want to know about it.
  def handle_resend_errored(error)
    Airbrake.notify error, registration: registration.reg_identifier
    Rails.logger.error "Error resending renewal email for registration #{registration.reg_identifier}"

    message = I18n.t("resend_renewal_email.messages.error.heading", email: registration.contact_email)
    description = I18n.t("resend_renewal_email.messages.error.details")

    flash_error(message, description)
  end
end
