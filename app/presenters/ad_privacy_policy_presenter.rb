# frozen_string_literal: true

class AdPrivacyPolicyPresenter < WasteCarriersEngine::BasePresenter

  def destination_path
    return renewal_path if reg_identifier.present?
    return resume_path if transient_registration.present?

    WasteCarriersEngine::Engine.routes.url_helpers.new_start_form_path
  end

  private

  def transient_registration
    @_transient_registration ||= find_transient_registration
  end

  def find_transient_registration
    WasteCarriersEngine::TransientRegistration.where(token: token).first if token.present?
  end

  def renewal_path
    WasteCarriersEngine::Engine.routes.url_helpers.new_renewal_start_form_path(token: reg_identifier)
  end

  def resume_path
    WasteCarriersEngine::Engine.routes.url_helpers.send(
      "new_#{transient_registration.workflow_state}_path".to_sym,
      token: transient_registration.token
    )
  end
end
