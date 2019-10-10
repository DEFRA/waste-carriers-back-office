# frozen_string_literal: true

module DashboardsHelper
  include WasteCarriersEngine::ApplicationHelper

  def inline_registered_address(result)
    address = displayable_address(result.registered_address)
    return nil if address.empty?

    address.join(", ")
  end

  def result_type(result)
    return "renewal" if result.is_a?(WasteCarriersEngine::TransientRegistration)
  end

  def can_be_resumed?(result)
    return false unless result.is_a?(WasteCarriersEngine::TransientRegistration)
    return false if result.renewal_application_submitted?
    return false if result.workflow_state == "worldpay_form"

    true
  end
end
