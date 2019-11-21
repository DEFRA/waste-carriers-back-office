# frozen_string_literal: true

class RenewingRegistrationPresenter < BaseRegistrationPresenter
  def display_current_workflow_state
    "#{I18n.t('.renewing_registrations.show.status.messages.in_progress')} \"#{current_workflow_state}\""
  end

  def rejected_header
    I18n.t(".renewing_registrations.show.status.headings.rejected")
  end

  def rejected_message
    I18n.t(".renewing_registrations.show.status.messages.rejected")
  end

  def display_expiry_date
    registration.expires_on&.to_date
  end

  def in_progress?
    !renewal_application_submitted?
  end

  private

  def current_workflow_state
    I18n.t("waste_carriers_engine.#{workflow_state}s.new.title", default: nil) ||
      I18n.t("waste_carriers_engine.#{workflow_state}s.new.heading", default: nil) ||
      workflow_state
  end
end
