# frozen_string_literal: true

class RenewingRegistrationsController < ApplicationController
  before_action :authenticate_user!

  def show
    begin
      transient_registration = WasteCarriersEngine::RenewingRegistration.find_by(reg_identifier: params[:reg_identifier])
    rescue Mongoid::Errors::DocumentNotFound
      if WasteCarriersEngine::Registration.where(reg_identifier: params[:reg_identifier]).any?
        return redirect_to registration_path(params[:reg_identifier])
      else
        return redirect_to bo_path
      end
    end

    @transient_registration = RenewingRegistrationPresenter.new(transient_registration, view_context)
  end
end
