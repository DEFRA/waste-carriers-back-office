# frozen_string_literal: true

class RegistrationPresenter < WasteCarriersEngine::BasePresenter
  def show_translation_or_filler(attribute)
    if send(attribute).present?
      I18n.t(".registrations.show.attributes.#{attribute}.#{send(attribute)}")
    else
      I18n.t(".registrations.show.filler")
    end
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

  def display_registered_address
    @view.displayable_address(registered_address)
  end

  def display_contact_address
    @view.displayable_address(contact_address)
  end

  def key_people_with_conviction_search_results?
    return false unless key_people.present?

    results = key_people.select(&:conviction_search_result)

    results.count.positive?
  end

  def number_of_people_with_matching_convictions
    return 0 unless key_people.present?

    all_requirements = key_people.map(&:conviction_check_required?)
    all_requirements.count(true)
  end
end
