# frozen_string_literal: true

module CanCompleteIfPossible
  extend ActiveSupport::Concern

  included do
    private

    def complete_if_possible
      return false unless can_complete?

      WasteCarriersEngine::RegistrationActivationService.run(registration: @resource)
      Notify::AdConfirmationLetterService.run(registration: @resource)

      true
    rescue StandardError => e
      Airbrake.notify(e, reg_identifier: @resource.reg_identifier)
      Rails.logger.error e

      false
    end

    def can_complete?
      @resource.is_a?(WasteCarriersEngine::Registration)
    end
  end
end
