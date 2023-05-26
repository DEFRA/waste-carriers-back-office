# frozen_string_literal: true

class RegistrationPresenter < BaseRegistrationPresenter
  def rejected_header
    I18n.t(".registrations.show.status.headings.rejected")
  end

  def rejected_message
    I18n.t(".registrations.show.status.messages.rejected")
  end

  def display_expiry_date
    expires_on&.to_date
  end

  def display_registration_status
    metaData.status.titleize
  end

  def display_registration_date
    metaData.dateRegistered&.to_date
  end

  def display_original_registration_date
    return if metaData.dateRegistered.blank?

    sanitize(I18n.t(".shared.registrations.company_details_panel.labels.registration_date_html",
                    formatted_date: display_registration_date))
  end
end
