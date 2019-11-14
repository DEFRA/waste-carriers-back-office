# frozen_string_literal: true

module RegistrationsHelper
  def show_translation_or_filler(attribute)
    if @registration[attribute].present?
      I18n.t(".registrations.show.attributes.#{attribute}.#{@registration[attribute]}")
    else
      I18n.t(".registrations.show.filler")
    end
  end

  def display_current_workflow_state
    I18n.t("waste_carriers_engine.#{@registration.workflow_state}s.new.title", default: nil) ||
      I18n.t("waste_carriers_engine.#{@registration.workflow_state}s.new.heading", default: nil) ||
      @registration.workflow_state
  end

  def display_expiry_date
    original_registration.expires_on.to_date
  end

  def display_registration_status
    original_registration.metaData.status.titleize
  end

  def display_registered_address
    displayable_address(@registration.registered_address)
  end

  def display_contact_address
    displayable_address(@registration.contact_address)
  end

  def key_people_with_conviction_search_results?
    return false unless @registration.key_people.present?

    results = @registration.key_people.select(&:conviction_search_result)

    results.count.positive?
  end

  def number_of_people_with_matching_convictions
    return 0 unless @registration.key_people.present?

    all_requirements = @registration.key_people.map(&:conviction_check_required?)
    all_requirements.count(true)
  end

  private

  def original_registration
    WasteCarriersEngine::Registration.where(reg_identifier: @registration.reg_identifier).first
  end
end
