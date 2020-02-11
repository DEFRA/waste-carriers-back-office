# frozen_string_literal: true

module ActionLinksHelper
  def details_link_for(resource)
    if a_transient_registration?(resource)
      renewing_registration_path(resource.reg_identifier)
    elsif a_registration?(resource)
      registration_path(resource.reg_identifier)
    end
  end

  def resume_link_for(resource)
    ad_privacy_policy_path(resource.reg_identifier)
  end

  def renew_link_for(resource)
    ad_privacy_policy_path(resource.reg_identifier)
  end

  def display_details_link_for?(resource)
    a_transient_registration?(resource) || a_registration?(resource)
  end

  def display_write_off_small_link_for?(resource)
    can?(:write_off_small, resource) && resource.balance != 0
  end

  def display_write_off_large_link_for?(resource)
    can?(:write_off_large, resource) && resource.balance != 0
  end

  def display_resume_link_for?(resource)
    return false unless display_transient_registration_links?(resource)
    return false if resource.renewal_application_submitted?
    return false if resource.workflow_state == "worldpay_form"

    can?(:renew, resource)
  end

  def display_payment_link_for?(resource)
    # TODO: Temporary - for release only. See: https://eaflood.atlassian.net/browse/RUBY-846
    return false if a_registration?(resource)

    resource.upper_tier?
  end

  def display_refund_link_for?(resource)
    return false if resource.balance >= 0

    can?(:refund, resource)
  end

  def display_revert_link?
    return false unless current_user

    %w[agency_with_refund agency_super finance_admin finance finance_super].include?(current_user.role)
  end

  def display_finance_details_link_for?(resource)
    # TODO: Temporary - for release only. See: https://eaflood.atlassian.net/browse/RUBY-846
    return false

    # rubocop:disable Lint/UnreachableCode
    resource.upper_tier? && resource.finance_details.present?
    # rubocop:enable Lint/UnreachableCode
  end

  def display_cease_or_revoke_link_for?(resource)
    return false unless display_registration_links?(resource)
    return false unless can?(:revoke, WasteCarriersEngine::Registration)
    return false unless can?(:cease, WasteCarriersEngine::Registration)

    resource.active?
  end

  def display_edit_link_for?(resource)
    # TODO: delete next line filter when internal route exists https://eaflood.atlassian.net/browse/RUBY-786
    return false if a_registration?(resource)
    return false unless display_registration_links?(resource)

    can?(:update, WasteCarriersEngine::Registration)
  end

  def display_certificate_link_for?(resource)
    return false unless display_registration_links?(resource)
    return false unless can?(:view_certificate, WasteCarriersEngine::Registration)

    resource.active?
  end

  def display_order_copy_cards_link_for?(resource)
    return false unless display_registration_links?(resource)
    return false unless can?(:order_copy_cards, WasteCarriersEngine::Registration)

    resource.active? && resource.upper_tier?
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

  private

  def display_transient_registration_links?(resource)
    a_transient_registration?(resource) && not_revoked_or_refused?(resource)
  end

  def display_registration_links?(resource)
    a_registration?(resource) && not_revoked_or_refused?(resource)
  end

  def a_registration?(resource)
    resource.is_a?(WasteCarriersEngine::Registration) || resource.is_a?(RegistrationPresenter)
  end

  def a_transient_registration?(resource)
    resource.is_a?(RenewingRegistrationPresenter) || resource.is_a?(WasteCarriersEngine::RenewingRegistration)
  end

  def not_revoked_or_refused?(resource)
    return false if resource.revoked?
    return false if resource.refused?

    true
  end
end
