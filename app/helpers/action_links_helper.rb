# frozen_string_literal: true

module ActionLinksHelper
  def details_link_for(resource)
    return "#" unless resource.is_a?(WasteCarriersEngine::TransientRegistration)

    transient_registration_path(resource.reg_identifier)
  end

  def resume_link_for(resource)
    return "#" unless resource.is_a?(WasteCarriersEngine::TransientRegistration)

    WasteCarriersEngine::Engine.routes.url_helpers.new_renewal_start_form_path(resource.reg_identifier)
  end

  def payment_link_for(resource)
    return "#" unless resource.is_a?(WasteCarriersEngine::TransientRegistration)

    transient_registration_payments_path(resource.reg_identifier)
  end

  def convictions_link_for(resource)
    if resource.is_a?(WasteCarriersEngine::TransientRegistration)
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
    resource.is_a?(WasteCarriersEngine::TransientRegistration)
  end

  def display_resume_link_for?(resource)
    return false unless display_transient_registration_links?(resource)
    return false if resource.renewal_application_submitted?
    return false if resource.workflow_state == "worldpay_form"

    can?(:renew, resource)
  end

  def display_payment_link_for?(resource)
    return false unless display_transient_registration_links?(resource)

    resource.pending_payment?
  end

  def display_convictions_link_for?(resource)
    return false unless display_transient_registration_links?(resource) || display_registration_links?(resource)
    return false unless can?(:review_convictions, resource)

    resource.pending_manual_conviction_check?
  end

  def display_renew_link_for?(resource)
    return false unless display_registration_links?(resource)
    return false unless can?(:renew, resource)

    resource.can_start_renewal?
  end

  def display_transfer_link_for?(resource)
    return false unless display_registration_links?(resource)

    can?(:transfer, resource)
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
end
