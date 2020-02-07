# frozen_string_literal: true

module CanRenewIfPossible
  extend ActiveSupport::Concern

  included do
    after_action :renew_if_possible, only: :create

    private

    def renew_if_possible
      return unless @resource.is_a?(WasteCarriersEngine::RenewingRegistration)

      renewal_completion_service = WasteCarriersEngine::RenewalCompletionService.new(@resource)
      renewal_completion_service.complete_renewal
    rescue StandardError => e
      Airbrake.notify(e, reg_identifier: @resource.reg_identifier)
      Rails.logger.error e
    end
  end
end
