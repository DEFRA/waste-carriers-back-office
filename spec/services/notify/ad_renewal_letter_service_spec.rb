# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notify::AdRenewalLetterService do
  describe "run" do
    let(:registration) { create(:registration, :expires_soon, :simple_address) }
    let(:service) do
      Notify::AdRenewalLetterService.run(registration: registration)
    end

    it "sends a letter" do
      VCR.use_cassette("notify_ad_renewal_letter") do
        # Make sure it's a real postcode for Notify validation purposes
        allow_any_instance_of(WasteCarriersEngine::Address).to receive(:postcode).and_return("BS1 1AA")

        expect_any_instance_of(Notifications::Client).to receive(:send_letter).and_call_original

        response = service

        expect(response).to be_a(Notifications::Client::ResponseNotification)
        expect(response.template["id"]).to eq("1b56d3a7-f7fd-414d-a3ba-2b50f627cf40")
        expect(response.reference).to match(/CBDU*/)
        expect(response.content["subject"]).to include("Renew your waste carrier registration")
      end
    end
  end
end
