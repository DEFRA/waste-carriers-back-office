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
end
