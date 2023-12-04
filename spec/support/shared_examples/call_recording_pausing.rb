# frozen_string_literal: true

RSpec.shared_examples "a controller that pauses call recording" do
  let(:user) { create(:user, role: :agency_super) }
  let(:call_recording_service) { instance_spy(CallRecordingService) }

  before do
    sign_in(user)
    allow(CallRecordingService).to receive(:new).with(user: user).and_return(call_recording_service)
  end

  context "when feature flag is on" do
    before do
      allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording).and_return(true)
      get path
    end

    it "returns http success" do
      get path
      expect(response).to have_http_status(:success)
    end

    it "pauses call recording" do
      expect(call_recording_service).to have_received(:pause)
    end
  end

  context "when feature flag is off" do
    before do
      allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording).and_return(false)
      get path
    end

    it "returns http success" do
      get path
      expect(response).to have_http_status(:success)
    end

    it "does not pause call recording" do
      expect(call_recording_service).not_to have_received(:pause)
    end
  end

  context "when determining form path" do
    before do
      allow(controller).to receive(:find_or_initialize_transient_registration).and_return(transient_registration)
      get path
    end

    it "generates the correct form path" do
      expect(controller.form_path).to eq(path)
    end
  end
end
