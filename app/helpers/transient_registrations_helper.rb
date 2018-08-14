# frozen_string_literal: true

module TransientRegistrationsHelper
  # Note that this is the application to renew, not a completed renewal. It just means that the user has submitted
  # all the required information through the forms, either through digital or assisted digital.
  def renewal_application_submitted?(transient_registration)
    not_in_progress_states = %w[renewal_received_form renewal_complete_form]
    not_in_progress_states.include?(transient_registration.workflow_state)
  end

  def show_translation_or_filler(attribute)
    if @transient_registration[attribute].present?
      I18n.t(".transient_registrations.show.attributes.#{attribute}.#{@transient_registration[attribute]}")
    else
      I18n.t(".transient_registrations.show.filler")
    end
  end

  def display_current_workflow_state
    I18n.t("waste_carriers_engine.#{@transient_registration.workflow_state}s.new.title", default: nil) ||
      I18n.t("waste_carriers_engine.#{@transient_registration.workflow_state}s.new.heading", default: nil) ||
      @transient_registration.workflow_state
  end

  def display_registered_address
    address_lines(@transient_registration.registered_address)
  end

  def display_contact_address
    address_lines(@transient_registration.contact_address)
  end

  def address_lines(address)
    [address.address_line_1,
     address.address_line_2,
     address.address_line_3,
     address.address_line_4,
     address.town_city,
     address.postcode,
     address.country].compact
  end

  def key_people_with_conviction_search_results?
    return false unless @transient_registration.key_people.present?

    results = @transient_registration.key_people.select(&:conviction_search_result)

    results.count.positive?
  end

  def number_of_people_with_matching_convictions
    return 0 unless @transient_registration.key_people.present?

    all_requirements = @transient_registration.key_people.map(&:conviction_check_required?)
    all_requirements.count(true)
  end
end
