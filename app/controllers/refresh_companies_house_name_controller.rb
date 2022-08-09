# frozen_string_literal: true

class RefreshCompaniesHouseNameController < ApplicationController
  include CanSetFlashMessages

  before_action :authenticate_user!

  def update_companies_house_details
    begin
      reg_identifier = params[:reg_identifier]
      WasteCarriersEngine::RefreshCompaniesHouseNameService.run(reg_identifier: reg_identifier)
      flash_success(
        I18n.t("refresh_companies_house_name.messages.success")
      )
    rescue StandardError
      Rails.logger.error "Failed to refresh"
      flash_error(
        I18n.t("refresh_companies_house_name.messages.failure"), nil
      )
    end

    redirect_back(fallback_location: registration_path(reg_identifier))
  end

  private

  def authenticate_user!
    authorize! :refresh_company_name, WasteCarriersEngine::Registration
  end
end
