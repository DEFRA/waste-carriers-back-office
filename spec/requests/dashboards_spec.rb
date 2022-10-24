# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboards" do
  describe "/bo" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      it "renders the index template and returns a 200 response" do
        get "/bo"

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
      end

      context "when a search term is included" do
        context "when there are matches" do
          it "links to renewal details pages" do
            last_modified_renewal = create(:renewing_registration)
            link_to_renewal = renewing_registration_path(last_modified_renewal.reg_identifier)

            get "/bo", params: { term: last_modified_renewal.reg_identifier }

            expect(response.body).to include(link_to_renewal)
          end
        end

        context "when fullname search is selected" do
          let(:first_name) { Faker::Name.first_name }
          let(:last_name) { Faker::Name.last_name }
          let!(:matching_renewal) { create(:renewing_registration, first_name: first_name, last_name: last_name) }
          let!(:matching_registration) { WasteCarriersEngine::Registration.where(reg_identifier: matching_renewal.reg_identifier).first }

          before do
            matching_registration.first_name = first_name
            matching_registration.last_name = last_name
            matching_registration.save!
          end

          it "links to renewal details pages" do
            link_to_renewal = renewing_registration_path(matching_renewal.reg_identifier)

            get "/bo", params: { term: "#{first_name} #{last_name}", search_fullname: "1" }

            expect(response.body).to include(link_to_renewal)
          end
        end

        context "when there are no matches" do
          it "says there are no results" do
            get "/bo", params: { term: "foobarbaz" }

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
