# frozen_string_literal: true

class NewRegistrationsController < ApplicationController
  before_action :authenticate_user!

  def show
    begin
      transient_registration = fetch_new_registration
    rescue Mongoid::Errors::DocumentNotFound
      return redirect_to bo_path
    end

    @transient_registration = NewRegistrationPresenter.new(transient_registration, view_context)
  end

  private

  def fetch_new_registration
    WasteCarriersEngine::NewRegistration.find_by(token: params[:token])
  end
end
