# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notify::DigitalRenewalLetterService do
  describe "run" do
    let(:registration) { create(:registration, :expires_soon, :simple_address) }
    let(:template_id) { "41ebbbc4-0d2f-425a-8d94-29e2beffd8ba" }
    let(:run_service) do
      VCR.use_cassette("notify_digital_renewal_letter") do
        described_class.run(registration: registration)
      end
    end

    before do
      # Make sure it's a real postcode for Notify validation purposes
      allow_any_instance_of(WasteCarriersEngine::Address).to receive(:postcode).and_return("BS1 1AA")
      allow_any_instance_of(Notifications::Client).to receive(:send_letter).and_call_original
    end

    it "sends a letter" do
      expect(run_service).to be_a(Notifications::Client::ResponseNotification)
      expect(run_service.template["id"]).to eq("41ebbbc4-0d2f-425a-8d94-29e2beffd8ba")
      expect(run_service.reference).to match(/CBDU*/)
      expect(run_service.content["subject"]).to include("You must renew your waste carrier registration")
    end

    it_behaves_like "can create a communication record", "letter"
  end
end
