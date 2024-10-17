# frozen_string_literal: true

class TransientRegistrationsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    transient_registration = WasteCarriersEngine::TransientRegistration.find_by(token: params[:token])
    redirect_path = Rails.application.routes.url_helpers.registration_path(
      reg_identifier: transient_registration.reg_identifier
    )

    transient_registration.destroy!

    redirect_to redirect_path
  end
end
