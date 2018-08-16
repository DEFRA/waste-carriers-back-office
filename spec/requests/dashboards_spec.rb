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

        let(:term) { matching_renewal.reg_identifier }

        before do
          last_modified_renewal.save
          matching_renewal.save
        end

        it "does not display the most recently modified, but non-matching, renewal" do
          link_to_renewal = transient_registration_path(last_modified_renewal.reg_identifier)

          get "/bo", term: term
          expect(response.body).to_not include(link_to_renewal)
        end

        context "when there is a match on a reg_identifier" do
          it "displays the matching renewal" do
            link_to_renewal = transient_registration_path(matching_renewal.reg_identifier)

            get "/bo", term: term
            expect(response.body).to include(link_to_renewal)
          end
        end

        context "when there is a match on a company_name" do
          let(:matching_company_name_renewal) { create(:transient_registration, company_name: "Acme") }
          let(:term) { matching_company_name_renewal.company_name }

          it "displays the matching renewal" do
            link_to_renewal = transient_registration_path(matching_company_name_renewal.reg_identifier)

            get "/bo", term: term
            expect(response.body).to include(link_to_renewal)
          end
        end

        context "when there is a match on a last_name" do
          let(:matching_last_name_renewal) { create(:transient_registration, last_name: "Aardvark") }
          let(:term) { matching_last_name_renewal.last_name }

          it "displays the matching renewal" do
            link_to_renewal = transient_registration_path(matching_last_name_renewal.reg_identifier)

            get "/bo", term: term
            expect(response.body).to include(link_to_renewal)
          end
        end

        context "when there is a match on a postcode" do
          let(:address) { build(:address, postcode: "AB1 2CD") }
          let(:matching_postcode_renewal) { create(:transient_registration, addresses: [address]) }
          let(:term) { address.postcode }

          it "displays the matching renewal" do
            link_to_renewal = transient_registration_path(matching_postcode_renewal.reg_identifier)

            get "/bo", term: term
            expect(response.body).to include(link_to_renewal)
          end
        end

        it "is case-insensitive" do
          link_to_renewal = transient_registration_path(matching_renewal.reg_identifier)

          get "/bo", term: term.downcase
          expect(response.body).to include(link_to_renewal)
        end

        context "when the matching renewal value includes the search term" do
          let(:partially_matching_renewal) { create(:transient_registration, last_name: "Aardvark") }
          let(:term) { "Aardva" }

          it "includes partial matches" do
            link_to_renewal = transient_registration_path(partially_matching_renewal.reg_identifier)

            get "/bo", term: term
            expect(response.body).to include(link_to_renewal)
          end
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
