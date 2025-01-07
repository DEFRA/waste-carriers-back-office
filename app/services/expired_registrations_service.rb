# frozen_string_literal: true

class ExpiredRegistrationsService < WasteCarriersEngine::BaseService
  def run
    expired_registrations = all_expired_registrations
    expired_registrations_counter = expired_registrations.size
    expired_registrations.each(&:expire!)

    expired_registrations_counter
  end

  private

  def all_expired_registrations
    WasteCarriersEngine::Registration.active.upper_tier.expired_at_end_of_today
  end
end
