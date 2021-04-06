# frozen_string_literal: true

require "rails_helper"

RSpec.describe NotifyDigitalRenewalLetterService do
  describe "run" do
    let(:registration) { create(:registration, :expires_soon) }
    let(:service) do
      NotifyDigitalRenewalLetterService.run(registration: registration)
    end

    it "sends a letter" do
      VCR.use_cassette("notify_digital_renewal_letter") do
        # Make sure it's a real postcode for Notify validation purposes
        allow_any_instance_of(WasteCarriersEngine::Address).to receive(:postcode).and_return("BS1 1AA")

        expect_any_instance_of(Notifications::Client).to receive(:send_letter).and_call_original

        response = service

        expect(response).to be_a(Notifications::Client::ResponseNotification)
        expect(response.template["id"]).to eq("41ebbbc4-0d2f-425a-8d94-29e2beffd8ba")
        expect(response.content["subject"]).to include("You must renew your waste carrier registration")
      end
    end
  end
end
