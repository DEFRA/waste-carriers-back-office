# frozen_string_literal: true

class WorldpayEscapesController < ApplicationController
  def new
    return unless set_up_valid_transient_registration?

    authorize

    if correct_workflow_state?
      change_state_to_payment_summary
      log_worldpay_escape
      redirect_to continue_renewal_path
    else
      redirect_to renewing_registration_path(@transient_registration.reg_identifier)
    end
  end

  private

  def set_up_valid_transient_registration?
    reg_identifier = params[:transient_registration_reg_identifier]
    @transient_registration = WasteCarriersEngine::RenewingRegistration.where(reg_identifier: reg_identifier)
                                                                       .first
  end

  def authorize
    authorize! :revert_to_payment_summary, @transient_registration
  end

  def correct_workflow_state?
    @transient_registration.workflow_state == "worldpay_form"
  end

  def change_state_to_payment_summary
    @transient_registration.update_attributes(workflow_state: "payment_summary_form")
  end

  def log_worldpay_escape
    params = {
      user: current_user.email,
      registration: @transient_registration.reg_identifier
    }
    Rails.logger.debug("#{params[:email]} sent #{params[:registration]} back to payment summary")
    Airbrake.notify("Sent back to payment summary", params)
  end

  def continue_renewal_path
    WasteCarriersEngine::Engine.routes.url_helpers.new_payment_summary_form_path(@transient_registration.token)
  end
end
