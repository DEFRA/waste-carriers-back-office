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

      context "when there is no search term" do
        let(:last_modified_renewal) { create(:transient_registration) }

        before do
          last_modified_renewal.save
        end

        it "displays the most recently modified renewal, regardless of content" do
          get "/bo"
          expect(response.body).to include(last_modified_renewal.reg_identifier)
        end
      end

      context "when there is a search term" do
        let(:last_modified_renewal) { create(:transient_registration) }
        let(:matching_renewal) { create(:transient_registration) }

        let(:term) do
          matching_renewal.reg_identifier
        end

        before do
          last_modified_renewal.save
          matching_renewal.save
        end

        it "displays the matching renewal" do
          get "/bo", term: term
          expect(response.body).to include(matching_renewal.reg_identifier)
        end

        it "does not display the most recently modified, but non-matching, renewal" do
          get "/bo", term: term
          expect(response.body).to_not include(last_modified_renewal.reg_identifier)
        end
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
