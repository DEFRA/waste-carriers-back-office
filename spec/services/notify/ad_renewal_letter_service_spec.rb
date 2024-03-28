# frozen_string_literal: true

require "rails_helper"

RSpec.describe Notify::AdRenewalLetterService do
  describe "#run" do
    subject(:run_service) do
      VCR.use_cassette("notify_ad_renewal_letter") do
        described_class.run(registration: registration)
      end
    end

    let(:registration) { create(:registration, :expires_soon) }
    let(:template_id) { "1b56d3a7-f7fd-414d-a3ba-2b50f627cf40" }
    let(:address) { build(:simple_address) }

    before do
      # Make sure it's a real postcode for Notify validation purposes
      allow(address).to receive(:postcode).and_return("BS1 1AA")
      allow(registration).to receive(:contact_address).and_return(address)
    end

    it "sends a letter" do
      expect(run_service).to be_a(Notifications::Client::ResponseNotification)
      expect(run_service.template["id"]).to eq("1b56d3a7-f7fd-414d-a3ba-2b50f627cf40")
      expect(run_service.reference).to match(/CBDU*/)
      expect(run_service.content["subject"]).to include("Renew your waste carrier registration")
    end

    it_behaves_like "can create a communication record", "letter"
  end
end
