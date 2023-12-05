# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Payment method confirmation forms" do
  describe "/bo/:token/payment-method-confirmation" do
    let(:user) { create(:user, role: :agency_super) }
    let(:transient_registration) { create(:new_registration, workflow_state: "payment_method_confirmation_form") }
    let(:path) { "/bo/#{transient_registration.token}/payment-method-confirmation" }

    before do
      sign_in(user)
      allow(CallRecordingService).to receive(:new).with(user: user).and_return(call_recording_service)
    end

    it_behaves_like "a controller that pauses call recording"
  end
end
