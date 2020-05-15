# frozen_string_literal: true

module WasteCarriersEngine
  module AdPrivacyPolicyHelper
    def destination_path
      if @reg_identifier.present?
        WasteCarriersEngine::Engine.routes.url_helpers.new_renewal_start_form_path(token: @reg_identifier)
      else
        WasteCarriersEngine::Engine.routes.url_helpers.new_start_form_path
      end
    end
  end
end
