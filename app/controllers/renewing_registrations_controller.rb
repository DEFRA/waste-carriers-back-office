# frozen_string_literal: true

class RenewingRegistrationsController < ApplicationController
  before_action :authenticate_user!

  def show
    transient_registration = WasteCarriersEngine::RenewingRegistration.find_by(reg_identifier: params[:reg_identifier])

    redirect_to bo_path unless transient_registration.present?

    @transient_registration = RenewingRegistrationPresenter.new(transient_registration, view_context)
  end
end
