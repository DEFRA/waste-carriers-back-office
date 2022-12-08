# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboards" do
  describe "/bo" do

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get "/bo"

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when a deactivated user is signed in" do
      before { sign_in(create(:user, :inactive)) }

      it "redirects to the deactivated page" do
        get "/bo"

        expect(response).to redirect_to("/bo/pages/deactivated")
      end
    end

    context "when a valid user is signed in" do
      before { sign_in(create(:user)) }

      it "renders the index template and returns a 200 response" do
        get "/bo"

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
      end

      context "when a search term is included" do

        context "when there are no matches" do
          it "says there are no results" do
            get "/bo", params: { term: "foobarbaz" }

            expect(response.body).to include("No results")
          end
        end

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
            get "/bo", params: { term: "#{first_name} #{last_name}", search_fullname: "1" }

            expect(response.body).to include(renewing_registration_path(matching_renewal.reg_identifier))
          end
        end

        context "when email search is selected" do

          subject(:search_request) {  get "/bo", params: { term: search_term, search_email: "1" } }

          let!(:matching_renewal) { create(:renewing_registration, contact_email: Faker::Internet.email) }
          let!(:matching_registration) { WasteCarriersEngine::Registration.where(reg_identifier: matching_renewal.reg_identifier).first }

          context "when both full name search and email search are selected" do
            it "returns a form validation error" do
              get "/bo", params: { term: "summat", search_fullname: "1", search_email: "1" }

              expect(request.flash[:error]).to be_present
            end
          end

          context "with an invalid email search term" do
            let(:search_term) { "foo_at_bar.com" }

            it "displays a validation error" do
              subject

              expect(request.flash[:error]).to eq("Enter a valid email address")
            end
          end

          context "with a valid email search term matching contact_email" do
            let(:search_term) { matching_registration.contact_email }

            it "includes links to the matched registrations" do
              subject

              expect(response.body).to include(registration_path(matching_registration.reg_identifier))
            end
          end

          context "with a valid email search term with whitespace otherwise matching contact_email" do
            let(:search_term) { " #{matching_registration.contact_email}   " }

            it "includes links to the matched registrations" do
              subject

              expect(response.body).to include(registration_path(matching_registration.reg_identifier))
            end
          end
        end
      end
    end
  end
end
