# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboards", type: :request do
  describe "/bo" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      it "renders the index template" do
        get "/bo"
        expect(response).to render_template(:index)
      end

      it "returns a 200 response" do
        get "/bo"
        expect(response).to have_http_status(200)
      end

      context "when a search term is included" do
        context "when there are matches" do
          it "links to renewal details pages" do
            last_modified_renewal = create(:renewing_registration)
            link_to_renewal = renewing_registration_path(last_modified_renewal.reg_identifier)

            get "/bo", term: last_modified_renewal.reg_identifier
            expect(response.body).to include(link_to_renewal)
          end
        end

        context "when there are no matches" do
          it "says there are no results" do
            get "/bo", term: "foobarbaz"
            expect(response.body).to include("No results")
          end
        end
      end
    end

    context "when a deactivated user is signed in" do
      before { sign_in(create(:user, :inactive)) }

      it "redirects to the deactivated page" do
        get "/bo"
        expect(response).to redirect_to("/bo/pages/deactivated")
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get "/bo"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
