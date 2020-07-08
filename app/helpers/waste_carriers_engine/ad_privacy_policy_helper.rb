# frozen_string_literal: true

module WasteCarriersEngine
  module AdPrivacyPolicyHelper
    def destination_path
      if @reg_identifier.present?
        WasteCarriersEngine::Engine.routes.url_helpers.new_renewal_start_form_path(token: @reg_identifier)
      elsif @transient_registration.present?
        resume_path_for(@transient_registration)
      else
        new_registration_path
        # WasteCarriersEngine::Engine.routes.url_helpers.new_start_form_path
      end
    end

    def resume_path_for(transient_registration)
      WasteCarriersEngine::Engine.routes.url_helpers.send(
        "new_#{transient_registration.workflow_state}_path".to_sym,
        token: transient_registration.token
      )
    end

    def new_registration_path
      if FeatureToggle.active?(:new_registration)
        WasteCarriersEngine::Engine.routes.url_helpers.new_start_form_path
      else
        File.join(Rails.configuration.wcrs_backend_url, "registrations/start")
      end
    end
  end
end
