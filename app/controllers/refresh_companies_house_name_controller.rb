# frozen_string_literal : true

class RefreshCompaniesHouseNameController < ApplicationController
  include CanSetFlashMessages

  before_action :authenticate_user!

  def update_companies_house_details

    begin
      Rails.logger.warn("INSIDE THE BEGIN UPDATE METHOD")
      #reg_identifier = params[:reg_identifier]
      WasteCarriersEngine::RefreshCompaniesHouseNameService.run(reg_identifier: resource.reg_identifier)

      Rails.logger.warn("AFTER THE API SERVICE CALL")

      flash_success(success_message)
    rescue StandardError
      Rails.logger.error "Failed to refresh"
      flash_error(failure_message, failure_desciption)
    end

    redirect_back(fallback_location: "/")
  end

  private

  def authenticate_user!
    authorize! :refresh_company_name, WasteCarriersEngine::Registration
  end

  def success_message
    I18n.t("refresh_companies_house_name.messages.success")
  end

  def failure_message
    I18n.t("refresh_companies_house_name.messages.failure")
  end

  def failure_desciption
    I18n.t("refresh_companies_house_name.messages.failure_details")
  end
end
