# frozen_string_literal: true

require WasteCarriersEngine::Engine.root.join(
  "app",
  "models",
  "waste_carriers_engine",
  "registration"
)

module WasteCarriersEngine
  class Registration
    def can_start_front_office_renewal?
      renewable_tier? && renewable_status? && renewable_front_office_date?
    end

    private

    def renewable_front_office_date?
      return true if check_service.in_standard_expiry_grace_window?
      return false if check_service.expired?

      check_service.in_renewal_window?
    end
  end
end
