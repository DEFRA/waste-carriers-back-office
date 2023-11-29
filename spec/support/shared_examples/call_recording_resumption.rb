# frozen_string_literal: true

RSpec.shared_examples "a controller that resumes call recording" do
  let(:user) { create(:user, role: :agency_super) }
  let(:call_recording_service) { instance_spy(CallRecordingService) }

  before do
    sign_in(user)
    allow(CallRecordingService).to receive(:new).with(user: user).and_return(call_recording_service)
  end

  it "returns http success" do
    get path
    expect(response).to have_http_status(:success)
  end

  context "when feature flag is on" do
    before do
      allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording).and_return(true)
      get path
    end

    it "resumes call recording" do
      expect(call_recording_service).to have_received(:resume)
    end

    it "sets the correct flash message on success" do
      allow(call_recording_service).to receive(:resume).and_return(true)
      get path
      expect(flash[:call_recording]).to eq(success: "Call recording has resumed")
    end

    it "sets the correct flash message on failure" do
      allow(call_recording_service).to receive(:resume).and_return(false)
      get path
      expect(flash[:call_recording]).to eq(error: "There is an issue with starting the call recording, please check that call recording has restarted")
    end
  end

  context "when feature flag is off" do
    before do
      allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording).and_return(false)
      get path
    end

    it "does not resume call recording" do
      expect(call_recording_service).not_to have_received(:resume)
    end
  end
end
