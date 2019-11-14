# frozen_string_literal: true

class RegistrationsController < ApplicationController
  before_action :authenticate_user!

  def show
    @registration = WasteCarriersEngine::Registration.where(reg_identifier: params[:reg_identifier])
                                                               .first
    redirect_to bo_path unless @registration.present?
  end
end
