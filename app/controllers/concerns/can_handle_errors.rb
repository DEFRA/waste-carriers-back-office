# frozen_string_literal: true

module CanHandleErrors
  extend ActiveSupport::Concern
  included do
    helper WasteCarriersEngine::ApplicationHelper
    include WasteCarriersEngine::CanAddDebugLogging
    # Most generic handler first:
    # https://apidock.com/rails/ActiveSupport/Rescuable/ClassMethods/rescue_from#518-Define-handlers-in-order-of-most-generic-to-most-specific
    rescue_from StandardError do |e|
      Airbrake.notify e
      Rails.logger.error "Unhandled exception: #{e}"
      log_transient_registration_details("Uncaught system error", e, @transient_registration)
      redirect_to "/bo/pages/system_error"
    end

    rescue_from CanCan::AccessDenied do
      redirect_to "/bo/pages/permission"
    end
  end
end
