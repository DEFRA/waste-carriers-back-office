# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users" do
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
        expect(response).to have_http_status(:ok)
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
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Show enabled users only")
        expect(response.body).to include(active_user.email)
        expect(response.body).to include(deactivated_user.email)
      end
    end

    context "when a signed in super user requests a CSV" do
      let(:user) { create(:user, :agency_super) }

      let(:headers) do
        {
          "Accept" => "text/csv",
          "Content-Type" => "text/csv"
        }
      end

      before do
        sign_in(user)
      end

      it "sends a CSV file containing a row for every user" do
        active_user = create(:user, email: "aaaaaaaaaaa@example.com")
        deactivated_user = create(:user, email: "aaaaaaaaaaa2@example.com", active: false)

        get "/bo/users/all", headers: headers

        expect(response).to have_http_status(:ok)
        expect(response.headers["Content-Type"]).to eq("text/csv")
        expect(response.headers["Content-Disposition"])
          .to eq "attachment; filename=\"users.csv\"; filename*=UTF-8''users.csv"
        expect(response.body.scan(active_user.email).size).to eq 1
        expect(response.body.scan(deactivated_user.email).size).to eq 1
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
