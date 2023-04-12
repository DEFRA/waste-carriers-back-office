# frozen_string_literal: true

class RegistrationRestoresController < ApplicationController
  include CanSetFlashMessages

  before_action :authenticate_user!
  before_action :authorize_action

  def new
    build_form(params[:registration_reg_identifier])
  end

  def create
    return unless build_form(params[:registration_reg_identifier])

    submit_form
  end

  private

  def build_form(reg_identifier)
    find_registration(reg_identifier)
    @registration_restore_form = RegistrationRestoreForm.new(@registration)
  end

  def find_registration(reg_identifier)
    @registration = WasteCarriersEngine::Registration.find_by(reg_identifier: reg_identifier)
  end

  def submit_form
    if @registration_restore_form.submit(params)
      update_metadata
      redirect_to registration_path(params[:registration_reg_identifier])
      true
    else
      render :new
      false
    end
  end

  def update_metadata
    @registration.metaData.status = "ACTIVE"
    @registration.metaData.restored_reason = @registration_restore_form.restored_reason
    @registration.metaData.restored_by = current_user.email
    @registration.save!
  end

  def authorize_action
    authorize! :restore, WasteCarriersEngine::Registration
  end
end
