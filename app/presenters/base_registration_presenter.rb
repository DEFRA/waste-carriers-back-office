# frozen_string_literal: true

class BaseRegistrationPresenter < WasteCarriersEngine::BasePresenter

  include ActionView::Helpers::SanitizeHelper

  delegate :balance, to: :finance_details, prefix: true

  def display_company_details_panel?
    company_name.present? ||
      display_tier_and_registration_type.present? ||
      display_expiry_text.present? ||
      account_email.present?
  end

  def display_contact_information_panel?
    first_name.present? ||
      phone_number.present? ||
      contact_email.present? ||
      contact_address.present?
  end

  def display_business_information_panel?
    company_name.present? ||
      company_no.present? ||
      registered_address.present? ||
      location.present?
  end

  def display_tier_and_registration_type
    [displayable_tier, displayable_registration_type].compact.join(" - ")
  end

  def displayable_location
    location = show_translation_or_filler(:location)

    sanitize(I18n.t(".shared.registrations.business_information.labels.location_html", location: location))
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

  def show_ceased_revoked_panel?
    revoked? || inactive?
  end

  def show_restored_panel?
    active? && metaData.restored_reason.present?
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
    return unless finance_details&.orders&.present?

    ::OrderPresenter.new(
      finance_details.orders.order_by(dateCreated: :desc).first
    )
  end

  def display_expiry_text
    return if expires_on.blank?
    return unless upper_tier?

    if expired?
      sanitize(I18n.t(".shared.registrations.labels.expired_html", formatted_date: display_expiry_date))
    else
      sanitize(I18n.t(".shared.registrations.labels.expires_html", formatted_date: display_expiry_date))
    end
  end

  def display_action_links_heading
    I18n.t(".shared.registrations.action_links_panel.actions_box.heading.with_reg_identifier",
           reg_identifier: reg_identifier)
  end

  def display_last_modifed
    metaData.last_modified.to_datetime
  end

  def ea_area
    registered_address.area || "Pending"
  end

  private

  def displayable_tier
    return if tier.blank?

    I18n.t(".shared.registrations.attributes.tier.#{tier.downcase}")
  end

  def displayable_registration_type
    return if registration_type.blank?

    I18n.t(".shared.registrations.company_details_panel.attributes.registration_type.#{registration_type}")
  end

  def show_translation_or_filler(attribute)
    if send(attribute).present?
      I18n.t(".shared.registrations.attributes.#{attribute}.#{send(attribute)}")
    else
      I18n.t(".shared.registrations.filler")
    end
  end
end
