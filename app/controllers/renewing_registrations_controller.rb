# frozen_string_literal: true

class RenewingRegistrationsController < ApplicationController
  before_action :authenticate_user!

  def show
    @transient_registration = WasteCarriersEngine::RenewingRegistration.where(reg_identifier: params[:reg_identifier])
                                                                       .first
    redirect_to bo_path unless @transient_registration.present?
  end
end
