# frozen_string_literal: true

class RegistrationPresenter < WasteCarriersEngine::BasePresenter
  def displayable_location
    location = show_translation_or_filler(:location)

    I18n.t(".registrations.show.business_information.labels.location", location: location)
  end

  def display_expiry_date
    expires_on&.to_date
  end

  def finance_details_link
    "#{Rails.configuration.wcrs_frontend_url}/registrations/#{id}/paymentstatus"
  end

  def display_registration_status
    metaData.status.titleize
  end

  private

  def show_translation_or_filler(attribute)
    if send(attribute).present?
      I18n.t(".registrations.show.attributes.#{attribute}.#{send(attribute)}")
    else
      I18n.t(".registrations.show.filler")
    end
  end
end
