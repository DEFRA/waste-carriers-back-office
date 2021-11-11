# frozen_string_literal: true

require "rails_helper"

RSpec.describe RemoveDeletableRegistrationsService do
  let!(:expired_8_years_ago) { create(:registration, :expired, expires_on: 8.years.ago) }
  let!(:expired_7_years_ago) { create(:registration, :expired, expires_on: 7.years.ago) }
  let!(:expired_6_years_ago) { create(:registration, :expired, expires_on: 6.years.ago) }
  let!(:not_expired) { create(:registration) }

  describe ".run" do
    it "removes the expired registrations" do
      expect(WasteCarriersEngine::Registration.all).to eq(
        [expired_8_years_ago, expired_7_years_ago, expired_6_years_ago, not_expired]
      )

      described_class.run

      expect(WasteCarriersEngine::Registration.all).to eq(
        [expired_6_years_ago, not_expired]
      )
    end
  end
end
