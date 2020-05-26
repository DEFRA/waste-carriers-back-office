# frozen_string_literal: true

class BaseRegistrationPresenter < WasteCarriersEngine::BasePresenter
  def display_company_details_panel?
    return true if company_name.present?
    return true if display_tier_and_registration_type.present?
    return true if display_expiry_text.present?
    return true if account_email.present?

    false
  end

  def display_contact_information_panel?
    return true if first_name.present?
    return true if phone_number.present?
    return true if contact_email.present?
    return true if contact_address.present?

    false
  end

  def display_business_information_panel?
    return true if company_name.present?
    return true if company_no.present?
    return true if registered_address.present?
    return true if location.present?

    false
  end

  def display_tier_and_registration_type
    [displayable_tier, displayable_business_type].compact.join(" - ")
  end

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

  def show_no_finance_details_data?
    upper_tier? && finance_details.blank?
  end

  def finance_details_balance
    finance_details.balance
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

  def show_order_details?
    finance_details&.orders&.any? && upper_tier?
  end

  def latest_order
    finance_details&.orders&.order_by(dateCreated: :desc)&.first
  end

  def display_expiry_text
    return unless upper_tier?

    if expired?
      I18n.t(".shared.registrations.labels.expired", formatted_date: display_expiry_date)
    else
      I18n.t(".shared.registrations.labels.expires", formatted_date: display_expiry_date)
    end
  end

  def display_action_links_heading
    text_path = ".shared.registrations.action_links_panel.actions_box.heading"
    if reg_identifier.present?
      I18n.t("#{text_path}.with_reg_identifier", reg_identifier: reg_identifier)
    elsif company_name.present?
      I18n.t("#{text_path}.with_company_name", company_name: company_name)
    else
      I18n.t("#{text_path}.without_company_name_or_reg_identifier")
    end
  end

  private

  def displayable_tier
    return unless tier.present?

    I18n.t(".shared.registrations.attributes.tier.#{tier.downcase}")
  end

  def displayable_business_type
    return unless business_type.present?

    I18n.t(".shared.registrations.attributes.business_type.#{business_type}")
  end

  def show_translation_or_filler(attribute)
    if send(attribute).present?
      I18n.t(".shared.registrations.attributes.#{attribute}.#{send(attribute)}")
    else
      I18n.t(".shared.registrations.filler")
    end
  end
end
