# frozen_string_literal: true

class ConvictionsController < ApplicationController
  before_action :authenticate_user!

  def index
    reg_identifier = params[:transient_registration_reg_identifier]
    @transient_registration = WasteCarriersEngine::TransientRegistration.where(reg_identifier: reg_identifier).first
    @registration = WasteCarriersEngine::Registration.where(reg_identifier: reg_identifier).first
  end
end
