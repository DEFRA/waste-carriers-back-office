# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Govpay webhooks API" do

  before { allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:api).and_return(true) }

  describe "POST /bo/api/govpay_webhooks/signature" do
    it "returns a valid hexadecimal value" do
      params = { foo: :bar }

      post "/bo/api/govpay_webhooks/signature", params: params.to_json, headers: { "CONTENT_TYPE" => "application/json" }

      puts "\n>>>> #{response.body}\n"
      expect(response.body.match(/^[0-9A-F]+$/i)).to be_present
    end
  end
end