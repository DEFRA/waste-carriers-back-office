# frozen_string_literal: true

class ConvictionsController < ApplicationController
  before_action :authenticate_user!

  def index
    assign_registration_and_transient_registration(params[:transient_registration_reg_identifier])
  end

  def begin_checks
    assign_registration_and_transient_registration(params[:reg_identifier])
    @transient_registration.conviction_sign_offs.first.begin_checks!

    redirect_to convictions_path
  end

  private

  def assign_registration_and_transient_registration(reg_identifier)
    @transient_registration = WasteCarriersEngine::TransientRegistration.where(reg_identifier: reg_identifier).first
    @registration = WasteCarriersEngine::Registration.where(reg_identifier: reg_identifier).first
  end
end
