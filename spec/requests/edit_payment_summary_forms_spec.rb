# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Edit payment summary form" do
  describe "/bo/edit-payment/:token" do
    let(:user) { create(:user, role: :agency_super) }
    let(:transient_registration) do
      create(:edit_registration, finance_details: build(:finance_details, :has_paid_order_and_payment))
    end
    let(:call_recording_service) { instance_spy(CallRecordingService) }

    before do
      sign_in(user)
      allow(CallRecordingService).to receive(:new).with(user: user).and_return(call_recording_service)
    end

    context "when feature flag is on" do
      before do
        allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording).and_return(true)
        get "/bo/#{transient_registration.token}/edit-payment"
      end

      it "pauses call recording" do
        expect(call_recording_service).to have_received(:pause)
      end
    end

    context "when feature flag is off" do
      before do
        allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording).and_return(false)
        get "/bo/#{transient_registration.token}/edit-payment"
      end

      it "does not pause call recording" do
        expect(call_recording_service).not_to have_received(:pause)
      end
    end
  end
end
