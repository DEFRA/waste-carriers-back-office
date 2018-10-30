# frozen_string_literal: true

class RegistrationTransfersController < ApplicationController
  before_action :authenticate_user!

  def new
    build_form(params[:reg_identifier])

    authorize_action
  end

  def create
    return false unless build_form(params[:registration_transfer_form][:reg_identifier])

    authorize_action

    submit_form
  end

  private

  def build_form(reg_identifier)
    find_registration(reg_identifier)
    @registration_transfer_form = RegistrationTransferForm.new(@registration)
  end

  def submit_form
    if @registration_transfer_form.submit(params[:registration_transfer_form])
      transfer_registration
      redirect_to bo_path
      true
    else
      render :new
      false
    end
  end

  def find_registration(reg_identifier)
    @registration = WasteCarriersEngine::Registration.where(reg_identifier: reg_identifier).first
  end

  def authorize_action
    authorize! :transfer_registration, @registration
  end

  def transfer_registration
    registration_transfer_service = RegistrationTransferService.new(@registration)
    registration_transfer_service.transfer_to_user(@registration_transfer_form.email)
  end
end
