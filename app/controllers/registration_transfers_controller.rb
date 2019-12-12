# frozen_string_literal: true

class RegistrationTransfersController < ApplicationController
  before_action :authenticate_user!

  def new
    build_form(params[:registration_reg_identifier])

    authorize_action
  end

  def create
    return false unless build_form(params[:registration_reg_identifier])

    authorize_action

    submit_form
  end

  def success
    find_registration(params[:registration_reg_identifier])
  end

  private

  def build_form(reg_identifier)
    find_registration(reg_identifier)
    @registration_transfer_form = RegistrationTransferForm.new(@registration)
  end

  def submit_form
    if @registration_transfer_form.submit(params[:registration_transfer_form])
      redirect_to registration_registration_transfer_success_path(params[:registration_reg_identifier])
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
end
