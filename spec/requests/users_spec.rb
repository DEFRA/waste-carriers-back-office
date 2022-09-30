# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "/bo/users" do
    context "when a super user is signed in" do
      let(:user) { create(:user, :agency_super) }

      before do
        sign_in(user)
      end

      it "renders the index template, returns a 200 response and includes the correct content" do
        active_user = create(:user, email: "aaaaaaaaaaa@example.com")
        deactivated_user = create(:user, email: "aaaaaaaaaaa2@example.com", active: false)

        get "/bo/users"

        expect(response).to render_template(:index)
        expect(response).to have_http_status(200)
        expect(response.body).to include("Manage back office users")
        expect(response.body).to include("Show all users")
        expect(response.body).to include(active_user.email)
        expect(response.body).not_to include(deactivated_user.email)
      end
    end

    context "when a non-super user is signed in" do
      let(:user) { create(:user, :agency) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/users"

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end

    context "when no user is signed in" do
      it "redirects the user to the sign in page" do
        get "/bo/users"

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "/bo/users/all" do
    context "when a super user is signed in" do
      let(:user) { create(:user, :agency_super) }

      before do
        sign_in(user)
      end

      it "renders the index template, returns a 200 response and includes the correct content" do
        active_user = create(:user, email: "aaaaaaaaaaa@example.com")
        deactivated_user = create(:user, email: "aaaaaaaaaaa2@example.com", active: false)

        get "/bo/users/all"

        expect(response).to render_template(:index)
        expect(response).to have_http_status(200)
        expect(response.body).to include("Show enabled users only")
        expect(response.body).to include(active_user.email)
        expect(response.body).to include(deactivated_user.email)
      end
    end

    context "when a non-super user is signed in" do
      let(:user) { create(:user, :agency) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/users/all"

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end

    context "when no user is signed in" do
      it "redirects the user to the sign in page" do
        get "/bo/users/all"

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
