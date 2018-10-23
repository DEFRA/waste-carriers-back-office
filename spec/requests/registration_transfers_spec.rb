# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RegistrationTransfers", type: :request do
  let(:registration) { create(:registration) }

  describe "GET /bo/transfer-registration" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      it "renders the new template" do
        get "/bo/transfer-registration/#{registration.reg_identifier}"
        expect(response).to render_template(:new)
      end

      it "includes the registration info on the page" do
        get "/bo/transfer-registration/#{registration.reg_identifier}"
        expect(response.body).to include("Transfer registration #{registration.reg_identifier}")
      end

      it "returns a 200 response" do
        get "/bo/transfer-registration/#{registration.reg_identifier}"
        expect(response).to have_http_status(200)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get "/bo/transfer-registration/#{registration.reg_identifier}"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /bo/transfer-registration" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to bo_path" do
        post "/bo/transfer-registration"
        expect(response).to redirect_to(bo_path)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        post "/bo/transfer-registration"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
