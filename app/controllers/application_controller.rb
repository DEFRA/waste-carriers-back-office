# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include WasteCarriersEngine::CanAddDebugLogging
  include CanAuthenticateUser
  include CanActAsBackOfficePage
end
