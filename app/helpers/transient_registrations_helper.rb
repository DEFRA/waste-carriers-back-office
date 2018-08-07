# frozen_string_literal: true

module TransientRegistrationsHelper
  def show_value_or_filler(attribute)
    @transient_registration[attribute] || "not set"
  end

  def display_current_workflow_state
    I18n.t("waste_carriers_engine.#{@transient_registration.workflow_state}s.new.title", default: nil) ||
      I18n.t("waste_carriers_engine.#{@transient_registration.workflow_state}s.new.heading", default: nil) ||
      @transient_registration.workflow_state
  end
end
