# frozen_string_literal: true

require "rails_helper"

RSpec.describe RemoveDeletableRegistrationsService do
  let!(:ceased_8_years_ago) { Timecop.freeze(8.years.ago) { create(:registration, :ceased) } }
  let!(:expired_8_years_ago) { Timecop.freeze(8.years.ago) { create(:registration, :expired) } }
  let!(:revoked_8_years_ago) { Timecop.freeze(8.years.ago) { create(:registration, :revoked) } }
  let!(:ceased) { create(:registration, :ceased) }
  let!(:expired) { create(:registration, :expired) }
  let!(:revoked) { create(:registration, :revoked) }

  describe ".run" do
    it "removes registrations expired/revoked/ceased > 7 years ago" do
      expect(WasteCarriersEngine::Registration.all).to eq(
        [
          ceased_8_years_ago,
          expired_8_years_ago,
          revoked_8_years_ago,
          ceased,
          expired,
          revoked
        ]
      )

      described_class.run

      expect(WasteCarriersEngine::Registration.all).to eq(
        [ceased, expired, revoked]
      )
    end
  end
end
