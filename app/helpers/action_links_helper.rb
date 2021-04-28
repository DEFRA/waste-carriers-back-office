# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength
module ActionLinksHelper
  def details_link_for(resource)
    if a_new_registration?(resource)
      new_registration_path(resource.token)
    elsif a_renewing_registration?(resource)
      renewing_registration_path(resource.reg_identifier)
    elsif a_registration?(resource)
      registration_path(resource.reg_identifier)
    end
  end

  def resume_link_for(resource)
    return ad_privacy_policy_path(token: resource.token) if a_new_registration?(resource)

    ad_privacy_policy_path(reg_identifier: resource.reg_identifier)
  end

  def renew_link_for(resource)
    ad_privacy_policy_path(reg_identifier: resource.reg_identifier)
  end

  def renewal_magic_link_for(resource)
    return nil unless a_registration?(resource)
    return nil unless resource.renew_token.present?

    RenewalMagicLinkService.run(token: resource.renew_token)
  end

  def display_write_off_small_link_for?(resource)
    can?(:write_off_small, resource) && resource.balance != 0
  end

  def display_write_off_large_link_for?(resource)
    can?(:write_off_large, resource) && resource.balance != 0
  end

  def display_resume_link_for?(resource)
    if a_new_registration?(resource)
      display_resume_link_for_new_registration?
    elsif a_renewing_registration?(resource)
      display_resume_link_for_renewal?(resource)
    else
      false
    end
  end

  def display_payment_link_for?(resource)
    return can_view_payments?(resource) unless a_renewing_registration?(resource)

    resource.renewal_application_submitted? && can_view_payments?(resource)
  end

  def display_refund_link_for?(resource)
    return false if resource.balance >= 0

    can?(:refund, resource)
  end

  def display_finance_details_link_for?(resource)
    return false if a_new_registration?(resource)
    return false unless resource.upper_tier? && resource.finance_details.present?
    return true unless a_renewing_registration?(resource)

    resource.renewal_application_submitted?
  end

  def display_cease_or_revoke_link_for?(resource)
    return false unless display_registration_links?(resource)
    return false unless can?(:revoke, WasteCarriersEngine::Registration)
    return false unless can?(:cease, WasteCarriersEngine::Registration)

    resource.active?
  end

  def display_edit_link_for?(resource)
    return false unless display_registration_links?(resource)
    return false unless can?(:edit, WasteCarriersEngine::Registration)

    resource.active?
  end

  def display_certificate_link_for?(resource)
    return false unless display_registration_links?(resource)
    return false unless can?(:view_certificate, WasteCarriersEngine::Registration)

    resource.active?
  end

  def display_resend_confirmation_email_link_for?(resource)
    return false unless display_registration_links?(resource)
    return false unless can?(:resend_confirmation_email, WasteCarriersEngine::Registration)

    resource.active?
  end

  def display_order_copy_cards_link_for?(resource)
    return false unless display_registration_links?(resource)
    return false unless can?(:order_copy_cards, WasteCarriersEngine::Registration)

    resource.active? && resource.upper_tier?
  end

  def display_cancel_link_for?(resource)
    return false unless display_registration_links?(resource)
    return false unless can?(:cancel, WasteCarriersEngine::Registration)

    resource.pending?
  end

  def display_renew_link_for?(resource)
    return false unless display_registration_links?(resource)
    return false unless can?(:renew, WasteCarriersEngine::Registration)

    resource.can_start_renewal?
  end

  def display_transfer_link_for?(resource)
    return false unless display_registration_links?(resource)

    can?(:transfer_registration, WasteCarriersEngine::Registration)
  end

  def display_ways_to_share_magic_link_for?(resource)
    return false unless WasteCarriersEngine::FeatureToggle.active?(:renewal_reminders)
    return false unless display_registration_links?(resource)
    return false unless can?(:renew, WasteCarriersEngine::Registration)

    resource.can_start_front_office_renewal?
  end

  private

  def display_renewing_registration_links?(resource)
    a_renewing_registration?(resource) && not_revoked_or_refused?(resource)
  end

  def display_registration_links?(resource)
    a_registration?(resource) && not_revoked_or_refused?(resource)
  end

  def a_registration?(resource)
    resource.is_a?(WasteCarriersEngine::Registration) || resource.is_a?(RegistrationPresenter)
  end

  def a_new_registration?(resource)
    resource.is_a?(NewRegistrationPresenter) || resource.is_a?(WasteCarriersEngine::NewRegistration)
  end

  def a_renewing_registration?(resource)
    resource.is_a?(RenewingRegistrationPresenter) || resource.is_a?(WasteCarriersEngine::RenewingRegistration)
  end

  def not_revoked_or_refused?(resource)
    return false if resource.revoked?
    return false if resource.refused?

    true
  end

  def can_view_payments?(resource)
    resource.upper_tier? && can?(:view_payments, resource)
  end

  def display_resume_link_for_new_registration?
    can?(:create, WasteCarriersEngine::Registration)
  end

  def display_resume_link_for_renewal?(resource)
    return false unless display_renewing_registration_links?(resource)
    return false if resource.renewal_application_submitted?
    return false if resource.workflow_state == "worldpay_form"

    can?(:renew, resource)
  end
end
# rubocop:enable Metrics/ModuleLength
