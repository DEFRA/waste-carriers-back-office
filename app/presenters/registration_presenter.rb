# frozen_string_literal: true

class RegistrationPresenter < BaseRegistrationPresenter
  def displayable_location
    location = show_translation_or_filler(:location)

    I18n.t(".registrations.show.business_information.labels.location", location: location)
  end

  def rejected_header
    I18n.t(".registrations.show.status.headings.rejected")
  end

  def rejected_message
    I18n.t(".registrations.show.status.messages.rejected")
  end

  def display_expiry_date
    expires_on&.to_date
  end

  def finance_details_link
    "#{Rails.configuration.wcrs_frontend_url}/registrations/#{id}/paymentstatus"
  end

  def edit_link
    "#{Rails.configuration.wcrs_frontend_url}/registrations/#{id}/edit?edit-process=1"
  end

  def view_confirmation_letter_link
    "#{Rails.configuration.wcrs_frontend_url}/registrations/#{id}/view"
  end

  def order_copy_cards_link
    "#{Rails.configuration.wcrs_frontend_url}/your-registration/#{id}/order-copy_cards"
  end

  def revoke_link
    "#{Rails.configuration.wcrs_frontend_url}/registrations/#{id}/revoke"
  end

  def cease_link
    "#{Rails.configuration.wcrs_frontend_url}/registrations/#{id}/confirm_delete"
  end

  def display_registration_status
    metaData.status.titleize
  end
end
