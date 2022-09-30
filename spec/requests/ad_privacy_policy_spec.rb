# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Assisted digital privacy policy", type: :request do
  let(:registration) { create(:registration, :expires_soon) }
  let(:user) { create(:user, :agency) }

  before do
    sign_in(user)
  end

  describe "GET /ad-privacy-policy/:reg_identifier" do
    it "renders the correct template and responds with a 200 status code" do
      get ad_privacy_policy_path(registration.reg_identifier)

      expect(response).to render_template("ad_privacy_policy/show")
      expect(response.code).to eq("200")
    end
  end
end
