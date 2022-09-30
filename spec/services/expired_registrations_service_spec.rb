# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExpiredRegistrationsService do
  describe ".run" do
    it "expires active upper tier registrations expiring by the end of the current day" do
      expired_registration = create(:registration, :active, expires_on: Time.zone.now.beginning_of_day + 4.hours)
      active_registration = create(:registration, :active, expires_on: Time.zone.now.end_of_day + 4.hours)
      lower_tier_registration = create(:registration, :active, tier: "LOWER", expires_on: Time.zone.now.beginning_of_day + 4.hours)

      expect(expired_registration).not_to be_expired
      expect(active_registration).not_to be_expired
      expect(lower_tier_registration).not_to be_expired

      described_class.run

      expired_registration.reload
      active_registration.reload
      lower_tier_registration.reload

      expect(expired_registration).to be_expired
      expect(active_registration).not_to be_expired
      expect(lower_tier_registration).not_to be_expired
    end
  end
end
