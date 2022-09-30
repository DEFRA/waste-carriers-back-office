# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notify::BulkAdRenewalLettersService do
  describe ".run" do
    let(:ad_registrations) { create_list(:registration, 2, :ad_registration, :expires_soon) }
    let(:non_ad_registration) { create(:registration, :expires_soon) }
    let(:non_matching_date_registration) { create(:registration, :ad_registration, :expires_tomorrow) }
    let(:inactive_registration) { create(:registration, :ad_registration, :expired) }

    let(:expires_on) { ad_registrations.first.expires_on }

    it "sends the relevant registrations to the Notify::AdRenewalLetterService" do
      expect(Airbrake).not_to receive(:notify)

      expect(Notify::AdRenewalLetterService).to receive(:run).with(registration: ad_registrations[0])
      expect(Notify::AdRenewalLetterService).to receive(:run).with(registration: ad_registrations[1])

      expect(Notify::AdRenewalLetterService).not_to receive(:run).with(registration: non_ad_registration)
      expect(Notify::AdRenewalLetterService).not_to receive(:run).with(registration: non_matching_date_registration)
      expect(Notify::AdRenewalLetterService).not_to receive(:run).with(registration: inactive_registration)

      described_class.run(expires_on)
    end

    context "when an error happens" do
      it "notifies Airbrake without failing the whole job" do
        allow(Notify::AdRenewalLetterService).to receive(:run).with(registration: ad_registrations[0]).and_raise("An error")
        expect(Airbrake).to receive(:notify).once
        expect(Notify::AdRenewalLetterService).to receive(:run).with(registration: ad_registrations[1])

        expect { described_class.run(expires_on) }.not_to raise_error
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
