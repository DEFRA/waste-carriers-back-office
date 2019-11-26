# frozen_string_literal: true

class RenewingRegistrationsController < ApplicationController
  before_action :authenticate_user!

  def show
    begin
      transient_registration = WasteCarriersEngine::RenewingRegistration.find_by reg_identifier: params[:reg_identifier]
    rescue Mongoid::Errors::DocumentNotFound
      scope = WasteCarriersEngine::Registration.where(reg_identifier: params[:reg_identifier])

      return redirect_to registration_path(params[:reg_identifier]) if scope.any?

      return redirect_to bo_path
    end

    @transient_registration = RenewingRegistrationPresenter.new(transient_registration, view_context)
  end
end
