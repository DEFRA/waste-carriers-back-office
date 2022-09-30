# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewalMagicLinkService do
  before(:each) do
    allow(Rails.configuration).to receive(:wcrs_renewals_url).and_return("http://example.com")
  end

  let(:service) do
    described_class.run(token: token)
  end

  context "when token is nil" do
    let(:token) { nil }

    it "returns the magic link without the token" do
      expect(service).to eq("http://example.com/fo/renew/")
    end
  end

  context "when the token is set" do
    let(:token) { "footoken" }

    it "returns a magic link with the token" do
      expect(service).to eq("http://example.com/fo/renew/#{token}")
    end
  end
end
