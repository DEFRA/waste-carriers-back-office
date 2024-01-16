# frozen_string_literal: true

module WasteCarriersEngine
  module CanRedirectFormToCorrectPath
    extend ActiveSupport::Concern

    included do
      def redirect_to_correct_form
        redirect_to form_path
      end

      # Get the path based on the workflow state, with token as params, ie:
      # new_state_name_path/:token or start_state_name_path?token=:token
      def form_path
        target = if engine_route?(@transient_registration.workflow_state)
                   basic_app_engine
                 else
                   Rails.application.routes.url_helpers
                 end

        target.send(:"new_#{@transient_registration.workflow_state}_path", token: @transient_registration.token)
      end

      def engine_route?(workflow_state)
        # routes will be "new_some_form_name" or "some_form_names"
        WasteCarriersEngine::Engine.routes.routes.any? do |r|
          ["new_#{workflow_state}", "#{workflow_state}s"].include? r.name
        end
      end
    end
  end
end
