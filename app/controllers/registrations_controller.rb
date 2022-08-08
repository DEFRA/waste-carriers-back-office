# frozen_string_literal: true

class RegistrationsController < ApplicationController
  before_action :authenticate_user!

  def show
    begin
      registration = WasteCarriersEngine::Registration.find_by(reg_identifier: params[:reg_identifier])
    rescue Mongoid::Errors::DocumentNotFound
      return redirect_to bo_path
    end

    @registration = RegistrationPresenter.new(registration, view_context)
  end
end
