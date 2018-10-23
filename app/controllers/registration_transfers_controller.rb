# frozen_string_literal: true

class RegistrationTransfersController < ApplicationController
  before_action :authenticate_user!

  def new
    find_registration(params[:reg_identifier])
  end

  def create
    redirect_to bo_path
  end

  private

  def find_registration(reg_identifier)
    @registration = WasteCarriersEngine::Registration.where(reg_identifier: reg_identifier).first
  end
end
