# frozen_string_literal: true

class ConvictionRejectionsController < ApplicationController
  before_action :authenticate_user!

  def new
    reg_identifier = params[:transient_registration_reg_identifier]
    @transient_registration = WasteCarriersEngine::TransientRegistration.where(reg_identifier: reg_identifier).first
  end
end
