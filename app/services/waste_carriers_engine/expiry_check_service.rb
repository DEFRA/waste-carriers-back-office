# frozen_string_literal: true

require WasteCarriersEngine::Engine.root.join(
  "app",
  "services",
  "waste_carriers_engine",
  "expiry_check_service"
)

module WasteCarriersEngine
  class ExpiryCheckService
    def in_expiry_grace_window?
      last_day_of_grace_window = if FeatureToggle.active?(:use_extended_grace_window)
                                   last_day_of_extended_grace_window
                                 else
                                   last_day_of_standard_grace_window
                                 end

      current_day_is_within_grace_window?(last_day_of_grace_window)
    end

    private

    def last_day_of_extended_grace_window
      (expiry_date.to_date + Rails.configuration.expires_after.years) - 1.day
    end
  end
end
