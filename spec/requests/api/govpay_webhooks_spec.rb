# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Govpay webhooks API" do
  let(:params) { { foo: :bar } }
  let(:signatures) { { front_office: Faker::Number.hexadecimal(digits: 20), back_office: Faker::Number.hexadecimal(digits: 20) } }
  let(:signature_service) { instance_double(DefraRubyGovpay::WebhookSignatureService) }

  before do
    allow(DefraRubyGovpay::WebhookSignatureService).to receive(:new).and_return(signature_service)
    allow(signature_service).to receive(:run).and_return(signatures)

    allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:api).and_return(true)

    post "/bo/api/govpay_webhooks/signatures", params: params.to_json, headers: { "CONTENT_TYPE" => "application/json" }
  end

  describe "POST /bo/api/govpay_webhooks/signatures" do
    it "calls the signature service" do
      expect(signature_service).to have_received(:run)
    end

    it "returns the front office and back office signatures" do
      expect(response.body).to eq(signatures.to_json)
    end
  end
end
