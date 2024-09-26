# frozen_string_literal: true

class RefreshEaAreaController < ApplicationController
  include CanSetFlashMessages

  before_action :authenticate_user!

  def update_ea_area
    begin
      reg_identifier = params[:reg_identifier]
      registration = WasteCarriersEngine::Registration.find_by(reg_identifier: reg_identifier)
      address = registration.company_address

      WasteCarriersEngine::UpdateAddressDetailsFromOsPlacesService.run(address:)

      raise StandardError if address.area.nil?

      address.save!

      flash_success(
        I18n.t("refresh_ea_area.messages.success")
      )
    rescue StandardError => e
      Rails.logger.error "Failed to refresh: #{e}"
      flash_error(
        I18n.t("refresh_ea_area.messages.failure"), nil
      )
    end

    redirect_back(fallback_location: registration_path(reg_identifier))
  end

  private

  def authenticate_user!
    authorize! :refresh_ea_area, WasteCarriersEngine::Registration
  end
end
