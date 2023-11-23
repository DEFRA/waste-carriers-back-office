# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Payment summary forms" do
  describe "/bo/payment-summary/:token" do
    let(:user) { create(:user, role: :agency_super) }
    let(:new_registration) { create(:new_registration) }
    let(:call_recording_service) { instance_spy(CallRecordingService) }

    before do
      sign_in(user)
      allow(CallRecordingService).to receive(:new).with(user: user).and_return(call_recording_service)
    end

    context "when feature flag is on" do
      before do
        allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording).and_return(true)
        get "/bo/#{new_registration.token}/payment-summary"
      end

      it "pauses call recording" do
        expect(call_recording_service).to have_received(:pause)
      end
    end

    context "when feature flag is off" do
      before do
        allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording).and_return(false)
        get "/bo/#{new_registration.token}/payment-summary"
      end

      it "does not pause call recording" do
        expect(call_recording_service).not_to have_received(:pause)
      end
    end
  end
end
