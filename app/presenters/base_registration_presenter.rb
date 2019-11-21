# frozen_string_literal: true

class BaseRegistrationPresenter < WasteCarriersEngine::BasePresenter
  def displayable_location
    location = show_translation_or_filler(:location)

    I18n.t(".shared.registrations.business_information.labels.location", location: location)
  end

  def display_convictions_check_message
    if lower_tier?
      I18n.t(".shared.registrations.conviction_search_text.lower_tier")
    elsif conviction_check_approved?
      I18n.t(".shared.registrations.conviction_search_text.approved")
    elsif rejected_conviction_checks?
      I18n.t(".shared.registrations.conviction_search_text.rejected")
    elsif conviction_search_result.present?
      I18n.t(".shared.registrations.conviction_search_text.#{conviction_check_required?}")
    else
      I18n.t(".shared.registrations.conviction_search_text.unknown")
    end
  end

  def in_progress?
    # TODO: For now all registrations are submitted in the new system. To update when we build front end flow.
    false
  end

  def show_ceased_revoked_panel?
    revoked? || inactive?
  end

  def ceased_revoked_header
    if revoked?
      I18n.t(".shared.registrations.ceased_revoked_panel.heading.revoked")
    elsif inactive?
      I18n.t(".shared.registrations.ceased_revoked_panel.heading.ceased")
    end
  end

  def show_finance_details_link?
    finance_details.present? && upper_tier?
  end

  def show_order_details?
    finance_details&.orders&.any? && upper_tier?
  end

  def order
    finance_details&.orders&.first
  end

  def display_expiry_text
    return unless upper_tier?

    if expired?
      I18n.t(".shared.registrations.labels.expired", formatted_date: display_expiry_date)
    else
      I18n.t(".shared.registrations.labels.expires", formatted_date: display_expiry_date)
    end
  end

  private

  def show_translation_or_filler(attribute)
    if send(attribute).present?
      I18n.t(".shared.registrations.attributes.#{attribute}.#{send(attribute)}")
    else
      I18n.t(".shared.registrations.filler")
    end
  end
end
