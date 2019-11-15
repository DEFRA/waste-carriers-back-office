# frozen_string_literal: true

class RegistrationsController < ApplicationController
  before_action :authenticate_user!

  def show
    registration = WasteCarriersEngine::Registration.find_by(reg_identifier: params[:reg_identifier])

    redirect_to bo_path unless registration.present?

    @registration = RegistrationPresenter.new(registration, view_context)
  end
end
