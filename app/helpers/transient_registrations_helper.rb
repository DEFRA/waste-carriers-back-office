# frozen_string_literal: true

module TransientRegistrationsHelper
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
     address.country].reject
  end

  def key_people_with_conviction_search_results?
    return false unless @transient_registration.key_people.present?

    results = @transient_registration.key_people.select(&:conviction_search_result)

    results.count.positive?
  end

  def number_of_people_with_matching_convictions
    return 0 unless @transient_registration.key_people.present?

    count = 0
    @transient_registration.key_people.each do |person|
      next unless person.conviction_search_result.present?
      next if person.conviction_search_result.match_result == "NO"
      count += 1
    end

    count
  end
end
