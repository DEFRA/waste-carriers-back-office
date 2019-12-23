# frozen_string_literal: true

class ExpiredRegistrationsService < ::WasteCarriersEngine::BaseService
  def run
    all_expired_registrations.each(&:expire!)
  end

  private

  def all_expired_registrations
    WasteCarriersEngine::Registration.active.upper_tier.expired_at_end_of_today
  end
end
