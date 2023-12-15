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

    it_behaves_like "pauses call recording"

    describe "payment confirmation payment methods" do
      before do
        allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:control_call_recording).and_return(true)
      end

      let(:call_recording_service) { instance_spy(CallRecordingService) }

      context "when user is on the bacs payment confirmation page" do
        before do
          transient_registration.temp_payment_method = "bank_transfer"
          transient_registration.save
          get path
        end

        it "does not pause call recording" do
          expect(call_recording_service).not_to have_received(:pause)
        end
      end

      context "when user is on the card payment confirmation page" do
        before do
          transient_registration.temp_payment_method = "card"
          transient_registration.save
          get path
        end

        it "pauses call recording" do
          expect(call_recording_service).to have_received(:pause)
        end
      end
    end
  end
end
