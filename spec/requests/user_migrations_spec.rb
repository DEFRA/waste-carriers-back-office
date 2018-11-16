# frozen_string_literal: true

require "rails_helper"

RSpec.describe "UserMigrations", type: :request do
  describe "GET /bo/users/migrate" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency_super) }
      before(:each) do
        sign_in(user)
      end

      it "renders the new template" do
        get "/bo/users/migrate"
        expect(response).to render_template(:new)
      end

      it "returns a 200 response" do
        get "/bo/users/migrate"
        expect(response).to have_http_status(200)
      end
    end

    context "when a non-super user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/users/migrate"
        expect(response).to redirect_to("/bo/permission")
      end
    end
  end

  describe "POST /bo/users/migrate" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency_super) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the users page" do
        post "/bo/users/migrate"
        expect(response).to redirect_to(users_path)
      end
    end

    context "when a non-super user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        post "/bo/users/migrate"
        expect(response).to redirect_to("/bo/permission")
      end
    end
  end
end
