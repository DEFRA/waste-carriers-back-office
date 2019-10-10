# frozen_string_literal: true

module ActionLinksHelper
  def display_resume_link_for?(resource)
    return false unless resource.is_a?(WasteCarriersEngine::TransientRegistration)
    return false if resource.renewal_application_submitted?
    return false if resource.workflow_state == "worldpay_form"

    true
  end
end
