# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notify::BulkDigitalRenewalNotificationService do
  describe ".run" do
    let(:registrations) { create_list(:registration, 2, :expires_soon) }
    let(:ad_registration) { create(:registration, :ad_registration, :expires_soon) }
    let(:non_matching_date_registration) { create(:registration, :expires_tomorrow) }
    let(:inactive_registration) { create(:registration, :expired) }
    let(:mobile_registration) { create(:registration, expires_on: expires_on, phone_number: "07837372722") }
    let(:active) { true }

    let(:expires_on) { registrations.first.expires_on }

    before do
      create(:feature_toggle, key: "send_digital_renewal_sms", active: active)
      allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:send_digital_renewal_sms).and_return(active)
    end

    describe "without errors" do
      let(:send_digital_renewal_sms) { false }

      before do
        create_registrations
        allow(Notify::DigitalRenewalLetterService).to receive(:run)
        allow(Notify::DigitalRenewalSmsService).to receive(:run)
        allow(Airbrake).to receive(:notify)

        described_class.run(expires_on)
      end

      context "when the feature toggle is on" do
        let(:active) { true }

        it "sends the relevant registrations to the Notify::DigitalRenewalLetterService" do
          expect(Airbrake).not_to have_received(:notify)

          expect(Notify::DigitalRenewalLetterService).to have_received(:run).with(registration: registrations[0])
          expect(Notify::DigitalRenewalLetterService).to have_received(:run).with(registration: registrations[1])

          expect(Notify::DigitalRenewalLetterService).not_to have_received(:run).with(registration: mobile_registration)
          expect(Notify::DigitalRenewalLetterService).not_to have_received(:run).with(registration: ad_registration)
          expect(Notify::DigitalRenewalLetterService).not_to have_received(:run).with(registration: non_matching_date_registration)
          expect(Notify::DigitalRenewalLetterService).not_to have_received(:run).with(registration: inactive_registration)
        end

        it "sends the relevant registrations to the Notify::DigitalRenewalSmsService" do
          expect(Airbrake).not_to have_received(:notify)

          expect(Notify::DigitalRenewalSmsService).to have_received(:run).with(registration: mobile_registration)
          expect(Notify::DigitalRenewalSmsService).not_to have_received(:run).with(registration: registrations[0])
          expect(Notify::DigitalRenewalSmsService).not_to have_received(:run).with(registration: registrations[1])
        end
      end

      context "when the feature toggle is off" do
        let(:active) { false }

        it "sends the relevant registrations to the Notify::DigitalRenewalLetterService" do
          expect(Airbrake).not_to have_received(:notify)

          expect(Notify::DigitalRenewalLetterService).to have_received(:run).with(registration: registrations[0])
          expect(Notify::DigitalRenewalLetterService).to have_received(:run).with(registration: registrations[1])
          expect(Notify::DigitalRenewalLetterService).to have_received(:run).with(registration: mobile_registration)

          expect(Notify::DigitalRenewalLetterService).not_to have_received(:run).with(registration: ad_registration)
          expect(Notify::DigitalRenewalLetterService).not_to have_received(:run).with(registration: non_matching_date_registration)
          expect(Notify::DigitalRenewalLetterService).not_to have_received(:run).with(registration: inactive_registration)
        end

        it "does not send the relevant registrations to the Notify::DigitalRenewalSmsService" do
          expect(Airbrake).not_to have_received(:notify)

          expect(Notify::DigitalRenewalSmsService).not_to have_received(:run).with(registration: mobile_registration)
          expect(Notify::DigitalRenewalSmsService).not_to have_received(:run).with(registration: registrations[0])
          expect(Notify::DigitalRenewalSmsService).not_to have_received(:run).with(registration: registrations[1])
        end
      end
    end

    describe "errors" do
      before do
        create_registrations
        allow(Notify::DigitalRenewalLetterService).to receive(:run)
        allow(Notify::DigitalRenewalSmsService).to receive(:run)
        allow(Airbrake).to receive(:notify)
      end

      context "when an error happens" do
        before do
          allow(Notify::DigitalRenewalLetterService).to receive(:run).with(registration: registrations[0]).and_raise("An error")
        end

        it "notifies Airbrake without failing the whole job" do
          described_class.run(expires_on)
          expect(Airbrake).to have_received(:notify).once
          expect(Notify::DigitalRenewalLetterService).to have_received(:run).with(registration: registrations[1])
        end
      end

      context "when sending an SMS raises an error" do
        before do
          allow(Notify::DigitalRenewalSmsService).to receive(:run).with(registration: mobile_registration).and_raise("An error")
        end

        it "notifies Airbrake without failing the whole job" do
          described_class.run(expires_on)
          expect(Airbrake).to have_received(:notify).once
          expect(Notify::DigitalRenewalSmsService).to have_received(:run).with(registration: mobile_registration)
        end
      end
    end

    context "when there are no registrations" do
      let(:expires_on) { 500.years.ago }

      it "returns a result" do
        expect(described_class.run(expires_on)).to eq([])
      end
    end
  end

  def create_registrations
    registrations
    ad_registration
    non_matching_date_registration
    inactive_registration
    mobile_registration
  end
end
