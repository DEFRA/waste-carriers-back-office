# frozen_string_literal: true

class ResendConfirmationEmailController < ApplicationController
  include CanSetFlashMessages
  include CanResendEmail

  before_action :authenticate_user!

  def new
    begin
      validate_contact_email(registration)

      WasteCarriersEngine::Notify::RegistrationConfirmationEmailService.run(registration: registration)

      flash_success(
        I18n.t("resend_confirmation_email.messages.success", email: registration.contact_email)
      )
    rescue Exceptions::MissingContactEmailError
      handle_missing_contact_email(:resend_confirmation_email)
    rescue StandardError => e
      handle_resend_errored(e, :resend_confirmation_email, "resending confirmation email")
    end

    redirect_back(fallback_location: "/")
  end

  private

  def authenticate_user!
    authorize! :resend_confirmation_email, WasteCarriersEngine::Registration
  end

  def registration
    @_registration ||= WasteCarriersEngine::Registration.find_by(reg_identifier: params[:reg_identifier])
  end
end
