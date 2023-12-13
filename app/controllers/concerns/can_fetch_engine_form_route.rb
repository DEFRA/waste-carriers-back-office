# frozen_string_literal: true

module CanFetchEngineFormRoute
  extend ActiveSupport::Concern

  included do

    def form_path
      # First try to resolve as an engine route
      basic_app_engine.send("new_#{@transient_registration.workflow_state}_path".to_sym,
                            token: @transient_registration.token)
    rescue NoMethodError
      # and if not found, resolve as a back-office form route
      send("new_#{@transient_registration.workflow_state}_path".to_sym, token: @transient_registration.token)
    end
  end
end
