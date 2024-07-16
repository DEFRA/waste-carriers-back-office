# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Govpay webhooks API" do
  let(:params) { { foo: :bar } }
  let(:signature) { Faker::Number.hexadecimal(digits: 20) }
  let(:signature_service) { instance_double(WasteCarriersEngine::GovpayPaymentWebhookSignatureService) }

  before do
    allow(WasteCarriersEngine::GovpayPaymentWebhookSignatureService).to receive(:new).and_return(signature_service)
    allow(signature_service).to receive(:run).and_return(signature)

    allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:api).and_return(true)

    post "/bo/api/govpay_webhooks/signature", params: params.to_json, headers: { "CONTENT_TYPE" => "application/json" }
  end

  describe "POST /bo/api/govpay_webhooks/signature" do
    it "calls the signature service" do
      expect(signature_service).to have_received(:run)
    end

    it "returns a valid hexadecimal value" do
      expect(response.body.match(/^[0-9A-F]+$/i)).to be_present
    end
  end
end
