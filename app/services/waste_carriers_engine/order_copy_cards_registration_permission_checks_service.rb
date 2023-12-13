# frozen_string_literal: true

module WasteCarriersEngine
  class OrderCopyCardsRegistrationPermissionChecksService < BaseRegistrationPermissionChecksService

    private

    def all_checks_pass?
      transient_registration_is_valid? && user_has_permission? && registration_is_active?
    end

    def user_has_permission?
      return true if can?(:order_copy_cards, registration)

      permission_check_result.needs_permissions!

      false
    end

    def registration_is_active?
      return true if registration.active?

      permission_check_result.invalid!

      false
    end
  end
end
