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

  def update_companies_house_details
    reg_identifier = params[:registration_reg_identifier]
    WasteCarriersEngine::RefreshCompaniesHouseNameService.run(reg_identifier: reg_identifier)

    redirect_back(fallback_location: registration_path(reg_identifier))
  end
end
