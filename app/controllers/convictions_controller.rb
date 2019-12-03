# frozen_string_literal: true

class ConvictionsController < ApplicationController
  before_action :authenticate_user!

  def index
    find_resource(params)
  end

  def begin_checks
    find_resource(find_renewing_registration(params[:reg_identifier]))
    @resource.conviction_sign_offs.first.begin_checks!

    redirect_to convictions_path
  end

  private

  def find_resource(params)
    if params[:registration_reg_identifier].present?
      find_registration(params[:registration_reg_identifier])
    elsif params[:transient_registration_reg_identifier].present?
      find_renewing_registration(params[:transient_registration_reg_identifier])
    end
  end

  def find_registration(reg_identifier)
    registration = WasteCarriersEngine::Registration.find_by(reg_identifier: reg_identifier)
    @resource = RegistrationConvictionPresenter.new(registration, view_context)
  end

  def find_renewing_registration(reg_identifier)
    renewing_registration = WasteCarriersEngine::RenewingRegistration.find_by(reg_identifier: reg_identifier)
    @resource = RenewingRegistrationConvictionPresenter.new(renewing_registration, view_context)
  end
end
