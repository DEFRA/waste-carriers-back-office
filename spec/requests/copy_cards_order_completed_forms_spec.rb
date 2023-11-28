# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Copy cards order complete form" do
  describe "/bo/order-copy-cards-complete/:token" do
    let(:user) { create(:user, role: :agency_super) }
    let(:transient_registration) do
      create(:renewing_registration, finance_details: build(:finance_details, :has_paid_order_and_payment), workflow_state: "copy_cards_order_completed_form")
    end
    let(:call_recording_service) { instance_spy(CallRecordingService) }

    before do
      sign_in(user)
      allow(CallRecordingService).to receive(:new).with(user: user).and_return(call_recording_service)
    end

    it "returns http success" do
      get "/bo/#{transient_registration.token}/order-copy-cards-complete"
      expect(response).to have_http_status(:success)
    end

    context "when feature flag is on" do
      before do
        allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording).and_return(true)
        get "/bo/#{transient_registration.token}/order-copy-cards-complete"
      end

      it "resumes call recording" do
        expect(call_recording_service).to have_received(:resume)
      end
    end

    context "when feature flag is off" do
      before do
        allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording).and_return(false)
        get "/bo/#{transient_registration.token}/order-copy-cards-complete"
      end

      it "does not resume call recording" do
        expect(call_recording_service).not_to have_received(:resume)
      end
    end
  end
end
