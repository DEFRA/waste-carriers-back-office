# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Assisted Digital Forms", type: :request do
  let(:renewal) { create(:renewing_registration) }

  describe "GET /bo/api/renewals/:reg_identifier" do
    context "when a user is signed in" do
      let(:user) { create(:user, :finance) }

      before(:each) do
        sign_in(user)
      end

      it "returns a json containing registration info" do
        get "/bo/api/renewals/#{renewal.reg_identifier}"

        expected_json = { "_id" => renewal.id.to_s, "token" => renewal.token }.to_json

        expect(response.body).to eq(expected_json)
      end
    end

    context "when no user is signed in" do
      it "returns a json containing an error" do
        get "/bo/api/renewals/#{renewal.reg_identifier}"

        expected_json = { "error" => "You need to sign in before continuing." }.to_json

        expect(response.body).to eq(expected_json)
      end
    end
  end
end
