# frozen_string_literal: true

class ConvictionsController < ApplicationController
  before_action :authenticate_user!

  def index
    find_resource(params[:transient_registration_reg_identifier])
  end

  def begin_checks
    find_resource(params[:reg_identifier])
    @resource.conviction_sign_offs.first.begin_checks!

    redirect_to convictions_path
  end

  private

  def find_resource(reg_identifier)
    @resource = WasteCarriersEngine::RenewingRegistration.where(reg_identifier: reg_identifier).first
  end
end
