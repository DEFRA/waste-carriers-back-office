# frozen_string_literal: true

module ActionLinksHelper
  def details_link_for(resource)
    case resource
    when WasteCarriersEngine::RenewingRegistration
      renewing_registration_path(resource.reg_identifier)
    when WasteCarriersEngine::Registration
      registration_path(resource.reg_identifier)
    else
      "#"
    end
  end

  def resume_link_for(resource)
    return "#" unless resource.is_a?(WasteCarriersEngine::RenewingRegistration)

    WasteCarriersEngine::Engine.routes.url_helpers.new_renewal_start_form_path(resource.reg_identifier)
  end

  def payment_link_for(resource)
    if resource.is_a?(WasteCarriersEngine::RenewingRegistration)
      transient_registration_payments_path(resource.reg_identifier)
    elsif resource.is_a?(WasteCarriersEngine::Registration)
      "#{Rails.configuration.wcrs_frontend_url}/registrations/#{resource.id}/paymentstatus"
    else
      "#"
    end
  end

  def convictions_link_for(resource)
    if resource.is_a?(WasteCarriersEngine::RenewingRegistration)
      transient_registration_convictions_path(resource.reg_identifier)
    elsif resource.is_a?(WasteCarriersEngine::Registration)
      "#{Rails.configuration.wcrs_frontend_url}/registrations/#{resource.id}/approve"
    else
      "#"
    end
  end

  def renew_link_for(resource)
    return "#" unless resource.is_a?(WasteCarriersEngine::Registration)

    WasteCarriersEngine::Engine.routes.url_helpers.new_renewal_start_form_path(resource.reg_identifier)
  end

  def transfer_link_for(resource)
    return "#" unless resource.is_a?(WasteCarriersEngine::Registration)

    new_registration_transfer_path(resource.reg_identifier)
  end

  def display_details_link_for?(resource)
    resource.is_a?(WasteCarriersEngine::RenewingRegistration) || resource.is_a?(WasteCarriersEngine::Registration)
  end

  def display_resume_link_for?(resource)
    return false unless display_transient_registration_links?(resource)
    return false if resource.renewal_application_submitted?
    return false if resource.workflow_state == "worldpay_form"

    can?(:renew, resource)
  end

  def display_payment_link_for?(resource)
    display_payment_details_link_for?(resource) && resource.pending_payment?
  end

  def display_payment_details_link_for?(resource)
    return false unless display_transient_registration_links?(resource) || display_registration_links?(resource)

    resource.upper_tier?
  end

  def display_revoke_link_for?(resource)
    return false unless display_registration_links?(resource)
    return false unless can?(:revoke, WasteCarriersEngine::Registration)

    resource.active?
  end

  def display_edit_link_for?(resource)
    return false unless display_registration_links?(resource)

    can?(:update, WasteCarriersEngine::Registration)
  end

  def display_view_confirmation_letter_link_for?(resource)
    return false unless display_registration_links?(resource)
    return false unless can?(:view_certificate, WasteCarriersEngine::Registration)

    resource.active?
  end

  def display_order_copy_cards_link_for?(resource)
    return false unless display_registration_links?(resource)
    return false unless can?(:order_copy_cards, WasteCarriersEngine::Registration)

    resource.active? && resource.upper_tier?
  end

  def display_convictions_link_for?(resource)
    return false unless display_transient_registration_links?(resource) || display_registration_links?(resource)
    return false unless can?(:review_convictions, WasteCarriersEngine::Registration)

    resource.pending_manual_conviction_check?
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

  def display_cease_link_for?(resource)
    return false unless display_registration_links?(resource)

    can?(:cease, WasteCarriersEngine::Registration)
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
    return false if resource.metaData.REVOKED?
    return false if resource.metaData.REFUSED?

    true
  end
end
