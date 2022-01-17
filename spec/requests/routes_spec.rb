# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Root", type: :request do
  describe "GET /" do
    before(:each) do
      sign_in(create(:user))
    end

    it "redirects to /bo and returns a 302 response" do
      get "/"

      expect(response).to redirect_to(bo_path)
      expect(response).to have_http_status(302)
    end
  end

  describe "GET /bo/[registration number]/renew" do
    context "when the user is not signed in" do
      let(:registration) { create(:registration, reg_identifier: "CBDU12345") }

      it "returns a 200 response and redirects the user to the sign in page" do
        get "/bo/CBDU12345/renew"

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(new_user_session_path)
      end

      it "redirects the user to the renewal start page after sign in" do
        user = create(:user)
        reg_identifier = create(:registration, :expires_soon, account_email: user.email).reg_identifier
        renew_path = "/bo/#{reg_identifier}/renew"

        get renew_path
        post user_session_path, params: { user: { email: user.email, password: user.password } }

        expect(response).to redirect_to(renew_path)
      end
    end

    context "when the user is signed in" do
      let(:user) { create(:user) }
      # We have to force invocation of creating the registration because we
      # don't directly reference it in our test, which means it doesn't get
      # created and the test fails.
      let!(:registration) { create(:registration, :expires_soon, account_email: user.email) }

      before(:each) do
        sign_in(user)
      end

      it "returns a 200 response and redirects the user to the renewal start page" do
        get "/bo/#{registration.reg_identifier}/renew"

        expect(response).to have_http_status(200)
        expect(response.body).to match(/You are about to renew registration CBDU\d+/)
      end
    end

    context "when a deactivated user is signed in" do
      let(:user) { create(:user, :inactive) }
      let(:registration) { create(:registration, reg_identifier: "CBDU12345") }

      before(:each) do
        sign_in(user)
      end

      it "returns a 302 (redirect) response" do
        get "/bo/#{registration.reg_identifier}/renew"

        expect(response).to have_http_status(302)
      end
    end
  end

  describe "GET /agency_users" do
    context "when the user goes to an old Devise sign-in URL" do
      it "returns a 301 and loads the new Devise URL" do
        get "/agency_users/sign_in"

        expect(response).to have_http_status(301)
        expect(response).to redirect_to("/bo/users/sign_in")
      end
    end

    context "when the user goes to an old Devise password URL" do
      it "returns a 301 and loads the new Devise URL" do
        get "/agency_users/password/edit"

        expect(response).to have_http_status(301)
        expect(response).to redirect_to("/bo/users/password/edit")
      end
    end
  end

  describe "GET /admins" do
    context "when the user goes to an old Devise sign-in URL" do
      it "returns a 301 and loads the new Devise URL" do
        get "/admins/sign_in"

        expect(response).to have_http_status(301)
        expect(response).to redirect_to("/bo/users/sign_in")
      end
    end

    context "when the user goes to an old Devise password URL" do
      it "returns a 301 and loads the new Devise URL" do
        get "/admins/password/edit"

        expect(response).to have_http_status(301)
        expect(response).to redirect_to("/bo/users/password/edit")
      end
    end
  end
end
