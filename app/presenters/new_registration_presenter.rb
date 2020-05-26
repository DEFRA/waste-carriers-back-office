# frozen_string_literal: true

class NewRegistrationPresenter < BaseRegistrationPresenter
  def display_heading
    if company_name.present?
      I18n.t(".new_registrations.show.heading.with_company_name", company_name: company_name)
    else
      I18n.t(".new_registrations.show.heading.without_company_name")
    end
  end

  def display_current_workflow_state
    "#{I18n.t('.new_registrations.show.status.messages.in_progress')} \"#{current_workflow_state}\""
  end

  private

  def current_workflow_state
    I18n.t("waste_carriers_engine.#{workflow_state}s.new.title", default: nil) ||
      I18n.t("waste_carriers_engine.#{workflow_state}s.new.heading", default: nil) ||
      workflow_state
  end
end
