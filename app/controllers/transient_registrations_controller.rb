# frozen_string_literal: true

class TransientRegistrationsController < ApplicationController
  before_action :authenticate_user!

  def show
    @transient_registration = WasteCarriersEngine::TransientRegistration.where(reg_identifier: params[:reg_identifier])
                                                                        .first

    @current_workflow_state = display_current_workflow_state(@transient_registration)
  end

  private

  def display_current_workflow_state(transient_registration)
    I18n.t("waste_carriers_engine.#{transient_registration.workflow_state}s.new.title", default: nil) ||
      I18n.t("waste_carriers_engine.#{transient_registration.workflow_state}s.new.heading", default: nil) ||
      transient_registration.workflow_state
  end
end
