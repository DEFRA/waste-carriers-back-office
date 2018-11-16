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

      it "copies unmigrated backend users" do
        agency_email = create(:agency_user).email
        matching_users_before_migration = User.where(email: agency_email).count
        post "/bo/users/migrate"
        expect(User.where(email: agency_email).count).to eq(matching_users_before_migration + 1)
      end

      it "redirects to the results page" do
        post "/bo/users/migrate"
        # We use include here so we don't have to check the details of the params
        expect(response.location).to include(user_migration_results_path)
      end
    end

    context "when a non-super user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "does not copy unmigrated backend users" do
        create(:agency_user)
        number_of_back_office_users = User.count
        post "/bo/users/migrate"
        expect(User.count).to eq(number_of_back_office_users)
      end

      it "redirects to the permissions error page" do
        post "/bo/users/migrate"
        expect(response).to redirect_to("/bo/permission")
      end
    end
  end

  describe "GET /bo/users/migrate/results" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency_super) }
      before(:each) do
        sign_in(user)
      end

      it "renders the new template" do
        get "/bo/users/migrate/results"
        expect(response).to render_template(:results)
      end

      it "returns a 200 response" do
        get "/bo/users/migrate/results"
        expect(response).to have_http_status(200)
      end

      context "when there are results" do
        let(:migration_results) do
          [{ action: "create", email: "foo@example.com", role: "agency_with_refund" },
           { action: "update", email: "bar@example.com", role: "finance" }]
        end
        let(:params) do
          { migration_results: migration_results }
        end

        it "displays an overview of results" do
          get "/bo/users/migrate/results", params
          expect(response.body).to include("1 user was added to the back office")
        end

        it "displays the emails on the page" do
          get "/bo/users/migrate/results", params
          expect(response.body).to include("bar@example.com")
        end

        it "displays the roles on the page" do
          get "/bo/users/migrate/results", params
          expect(response.body).to include("agency with refund")
        end
      end

      context "when there no are results" do
        it "displays an error" do
          get "/bo/users/migrate/results"
          expect(response.body).to include("No results")
        end
      end
    end

    context "when a non-super user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/users/migrate/results"
        expect(response).to redirect_to("/bo/permission")
      end
    end
  end
end
