# frozen_string_literal: true

require "rails_helper"

RSpec.describe NotifyBulkAdRenewalLettersService do
  describe ".run" do
    let(:ad_registrations) { create_list(:registration, 2, :ad_registration, :expires_soon) }
    let(:non_ad_registration) { create(:registration, :expires_soon) }
    let(:non_matching_date_registration) { create(:registration, :ad_registration, :expires_tomorrow) }
    let(:inactive_registration) { create(:registration, :ad_registration, :expired) }

    let(:expires_on) { ad_registrations.first.expires_on }

    it "sends the relevant registrations to the NotifyAdRenewalLetterService" do
      expect(Airbrake).to_not receive(:notify)

      expect(NotifyAdRenewalLetterService).to receive(:run).with(registration: ad_registrations[0])
      expect(NotifyAdRenewalLetterService).to receive(:run).with(registration: ad_registrations[1])

      expect(NotifyAdRenewalLetterService).to_not receive(:run).with(registration: non_ad_registration)
      expect(NotifyAdRenewalLetterService).to_not receive(:run).with(registration: non_matching_date_registration)
      expect(NotifyAdRenewalLetterService).to_not receive(:run).with(registration: inactive_registration)

      described_class.run(expires_on)
    end

    context "when an error happens" do
      it "notifies Airbrake without failing the whole job" do
        expect(NotifyAdRenewalLetterService).to receive(:run).with(registration: ad_registrations[0]).and_raise("An error")
        expect(Airbrake).to receive(:notify).once
        expect(NotifyAdRenewalLetterService).to receive(:run).with(registration: ad_registrations[1])

        expect { described_class.run(expires_on) }.to_not raise_error
      end
    end

    context "when there are no registrations" do
      let(:expires_on) { 500.years.ago }

      it "returns a result" do
        expect(described_class.run(expires_on)).to eq([])
      end
    end
  end
end
