# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include CanHandleErrors
  include CanAuthenticateUser
  include CanActAsBackOfficePage
end
