# frozen_string_literal: true

module CanRenewIfPossible
  extend ActiveSupport::Concern

  included do
    private

    def renew_if_possible
      return false unless can_renew?

      renewal_completion_service.complete_renewal

      true
    rescue StandardError => e
      Airbrake.notify(e, reg_identifier: @resource.reg_identifier)
      Rails.logger.error e

      false
    end

    def can_renew?
      return false unless @resource.is_a?(WasteCarriersEngine::RenewingRegistration)

      renewal_completion_service.can_be_completed?
    end

    def renewal_completion_service
      @_renewal_completion_service ||= WasteCarriersEngine::RenewalCompletionService.new(@resource)
    end
  end
end
