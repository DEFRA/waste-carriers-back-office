# frozen_string_literal: true

module ActionLinksHelper
  def display_details_link_for?(resource)
    resource.is_a?(WasteCarriersEngine::TransientRegistration)
  end

  def display_resume_link_for?(resource)
    return false unless display_transient_registration_links?(resource)
    return false if resource.renewal_application_submitted?
    return false if resource.workflow_state == "worldpay_form"

    true
  end

  def display_payment_link_for?(resource)
    return false unless display_transient_registration_links?(resource)

    resource.pending_payment?
  end

  def display_convictions_link_for?(resource)
    return false unless display_transient_registration_links?(resource)

    resource.pending_manual_conviction_check?
  end

  def display_renew_link_for?(resource)
    return false unless display_registration_links?(resource)

    renewable_tier?(resource) && renewable_status?(resource) && renewable_date?(resource)
  end

  def display_transfer_link_for?(resource)
    display_registration_links?(resource)
  end

  private

  def display_transient_registration_links?(resource)
    resource.is_a?(WasteCarriersEngine::TransientRegistration) && not_revoked_or_refused?(resource)
  end

  def display_registration_links?(resource)
    resource.is_a?(WasteCarriersEngine::Registration) && not_revoked_or_refused?(resource)
  end

  def not_revoked_or_refused?(resource)
    return false if resource.metaData.REVOKED?
    return false if resource.metaData.REFUSED?

    true
  end

  def renewable_tier?(resource)
    resource.tier == "UPPER"
  end

  def renewable_status?(resource)
    %w[ACTIVE EXPIRED].include?(resource.metaData.status)
  end

  def renewable_date?(resource)
    check_service = WasteCarriersEngine::ExpiryCheckService.new(resource)
    return true if check_service.in_expiry_grace_window?
    return false if check_service.expired?

    check_service.in_renewal_window?
  end
end
