# frozen_string_literal: true

class RegistrationTransfersController < ApplicationController
  before_action :authenticate_user!

  def new
    find_registration(params[:reg_identifier])
    authorize_action
  end

  def create
    find_registration(params[:registration_transfer_form][:reg_identifier])
    authorize_action
    redirect_to bo_path
  end

  private

  def find_registration(reg_identifier)
    @registration = WasteCarriersEngine::Registration.where(reg_identifier: reg_identifier).first
  end

  def authorize_action
    authorize! :transfer_registration, @registration
  end
end
