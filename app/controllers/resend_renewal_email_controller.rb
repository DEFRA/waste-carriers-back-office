# frozen_string_literal: true

class ResendRenewalEmailController < ApplicationController
  before_action :authenticate_user!

  def new
    begin
      RenewalReminderMailer.second_reminder_email(registration).deliver_now

      flash[:success] = I18n.t("resend_renewal_email.messages.success", email: registration.contact_email)
    rescue StandardError => e
      Airbrake.notify e, registration: registration.reg_identifier
      Rails.logger.error "Failed to send renewal email for registration #{registration.reg_identifier}"

      flash[:message] = I18n.t("resend_renewal_email.messages.failure", email: registration.contact_email)
    end

    redirect_back(fallback_location: "/")
  end

  private

  def registration
    @_registration ||= WasteCarriersEngine::Registration.find_by(reg_identifier: params[:reg_identifier])
  end

  def authenticate_user!
    authorize! :renew, WasteCarriersEngine::Registration
  end
end
