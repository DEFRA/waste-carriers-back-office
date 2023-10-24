# frozen_string_literal: true

class RenewingRegistrationsController < ApplicationController
  before_action :authenticate_user!

  def show
    begin
      @back_link = request.referer || bo_path
      transient_registration = fetch_renewing_registration
    rescue Mongoid::Errors::DocumentNotFound
      scope = WasteCarriersEngine::Registration.where(reg_identifier: params[:reg_identifier])

      return redirect_to registration_path(params[:reg_identifier]) if scope.any?

      return redirect_to bo_path
    end

    @transient_registration = RenewingRegistrationPresenter.new(transient_registration, view_context)
  end

  def destroy
    reg_identifier = params[:reg_identifier]

    WasteCarriersEngine::RenewingRegistration.where(reg_identifier: reg_identifier).destroy

    redirect_back(fallback_location: registration_path(reg_identifier))
  end

  private

  def fetch_renewing_registration
    WasteCarriersEngine::RenewingRegistration.find_by(reg_identifier: params[:reg_identifier])
  end
end
