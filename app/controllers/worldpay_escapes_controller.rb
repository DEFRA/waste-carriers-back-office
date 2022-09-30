# frozen_string_literal: true

class WorldpayEscapesController < ApplicationController
  include CanFetchResource

  prepend_before_action :authenticate_user!
  before_action :authorize, only: %i[new]

  def new
    if correct_workflow_state?
      change_state_to_payment_summary
      log_worldpay_escape
      redirect_to continue_journey_path
    else
      redirect_to details_page_path
    end
  end

  private

  def authorize
    authorize! :revert_to_payment_summary, @resource
  end

  def correct_workflow_state?
    @resource.workflow_state == "worldpay_form"
  end

  def change_state_to_payment_summary
    @resource.update(workflow_state: "payment_summary_form")
  end

  def log_worldpay_escape
    params = {
      user: current_user.email,
      class: @resource.class.name,
      reg_identifier: @resource.reg_identifier,
      token: @resource.token
    }
    Rails.logger.debug { "#{params[:email]} sent #{params[:name]} #{params[:registration]} back to payment summary" }
    Airbrake.notify("Sent back to payment summary", params)
  end

  def continue_journey_path
    WasteCarriersEngine::Engine.routes.url_helpers.new_payment_summary_form_path(@resource.token)
  end

  def details_page_path
    if @resource.is_a?(WasteCarriersEngine::RenewingRegistration)
      renewing_registration_path(@resource.reg_identifier)
    else
      new_registration_path(@resource.token)
    end
  end
end
