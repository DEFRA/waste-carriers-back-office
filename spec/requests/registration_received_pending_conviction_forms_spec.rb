# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RegistrationReceivedPendingConvictionForms" do
  let(:user) { create(:user, role: :agency_super) }
  let(:transient_registration) { create(:new_registration, :has_required_data, workflow_state: "registration_received_pending_conviction_form") }
  let(:call_recording_service) { instance_spy(CallRecordingService) }

  before do
    sign_in(user)
    allow(CallRecordingService).to receive(:new).with(user: user).and_return(call_recording_service)
  end

  describe "GET /new" do
    it "returns http success" do
      get "/bo/#{transient_registration.token}/registration-received"
      expect(response).to have_http_status(:success)
    end

    context "when feature flag is on" do
      before do
        allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording).and_return(true)
        get "/bo/#{transient_registration.token}/registration-received"
      end

      it "resumes call recording" do
        expect(call_recording_service).to have_received(:resume)
      end
    end

    context "when feature flag is off" do
      before do
        allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording).and_return(false)
        get "/bo/#{transient_registration.token}/registration-received"
      end

      it "does not resume call recording" do
        expect(call_recording_service).not_to have_received(:resume)
      end
    end
  end
end
