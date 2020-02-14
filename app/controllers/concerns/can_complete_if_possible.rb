# frozen_string_literal: true

module CanCompleteIfPossible
  extend ActiveSupport::Concern

  included do
    private

    def complete_if_possible
      return false unless @resource.is_a?(WasteCarriersEngine::Registration)

      WasteCarriersEngine::RegistrationCompletionService.run(registration: @resource)

      true
    rescue StandardError => e
      Airbrake.notify(e, reg_identifier: @resource.reg_identifier)
      Rails.logger.error e

      false
    end
  end
end
