# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "/bo/users" do
    context "when a super user is signed in" do
      let(:user) { create(:user, :agency_super) }
      before(:each) do
        sign_in(user)
      end

      it "renders the index template" do
        get "/bo/users"
        expect(response).to render_template(:index)
      end

      it "returns a 200 response" do
        get "/bo/users"
        expect(response).to have_http_status(200)
      end

      it "includes the correct content" do
        get "/bo/users"
        expect(response.body).to include("Manage back office users")
      end

      it "displays a list of users" do
        listed_user = create(:user)
        get "/bo/users"
        expect(response.body).to include(listed_user.email)
      end
    end

    context "when a non-super user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/users"
        expect(response).to redirect_to("/bo/permission")
      end
    end

    context "when no user is signed in" do
      it "redirects the user to the sign in page" do
        get "/bo/users"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
