# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registrations API", type: :request do
  let(:registration) { create(:registration) }

  before do
    allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:api).and_return(true)
  end

  describe "GET /bo/api/registrations/:reg_identifier" do
    it "returns a json containing registration info" do
      get "/bo/api/registrations/#{registration.reg_identifier}"

      expected_json = { "_id" => registration.id.to_s }.to_json

      expect(response.body).to eq(expected_json)
    end
  end

  describe "POST /bo/api/registrations" do
    let(:data) { File.read("#{Rails.root}/spec/support/fixtures/registration_seed.json") }

    it "generates a new registration and returns a json containing its info" do
      expected_registrations_count = WasteCarriersEngine::Registration.count + 1

      post "/bo/api/registrations", data, format: :json

      expect(response.code).to eq("200")
      expect(WasteCarriersEngine::Registration.count).to eq(expected_registrations_count)
    end
  end
end
