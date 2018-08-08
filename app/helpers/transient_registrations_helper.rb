# frozen_string_literal: true

module TransientRegistrationsHelper
  def show_value_or_filler(attribute)
    @transient_registration[attribute] || "-"
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
    lines = []

    if address.present?
      lines = [address.address_line_1,
       address.address_line_2,
       address.address_line_3,
       address.address_line_4,
       address.town_city,
       address.postcode,
       address.country].reject
    else
      lines = ["-"]
    end

    lines
  end
end
