# frozen_string_literal: true

class WorldpayEscapesController < ApplicationController
  def new
    return unless set_up_valid_transient_registration?

    redirect_to continue_renewal_path
  end

  private

  def set_up_valid_transient_registration?
    reg_identifier = params[:transient_registration_reg_identifier]
    @transient_registration = WasteCarriersEngine::TransientRegistration.where(reg_identifier: reg_identifier)
                                                                        .first
  end

  def continue_renewal_path
    WasteCarriersEngine::Engine.routes.url_helpers.new_renewal_start_form_path(@transient_registration.reg_identifier)
  end
end
