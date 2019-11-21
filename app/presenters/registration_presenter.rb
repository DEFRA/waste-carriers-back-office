# frozen_string_literal: true

class RegistrationPresenter < BaseRegistrationPresenter
  def display_expiry_date
    expires_on&.to_date
  end

  def finance_details_link
    "#{Rails.configuration.wcrs_frontend_url}/registrations/#{id}/paymentstatus"
  end

  def display_registration_status
    metaData.status.titleize
  end
end
