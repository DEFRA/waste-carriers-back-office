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

      context "when there are no filters" do
        context "when there is no search term" do
          let(:last_modified_renewal) { create(:transient_registration) }

          before do
            last_modified_renewal.save
          end

          it "displays the most recently modified renewal, regardless of content" do
            link_to_renewal = transient_registration_path(last_modified_renewal.reg_identifier)

            get "/bo"
            expect(response.body).to include(link_to_renewal)
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

          context "when there is a partial match on the reg_identifier" do
            let(:partially_matching_renewal) { create(:transient_registration) }
            let(:term) { partially_matching_renewal.reg_identifier.chop }

            it "does not include the partial match" do
              link_to_renewal = transient_registration_path(partially_matching_renewal.reg_identifier)

              get "/bo", term: term
              expect(response.body).to_not include(link_to_renewal)
            end
          end

          context "when there is a partial match on the last_name" do
            let(:partially_matching_renewal) { create(:transient_registration, last_name: "Aardvark") }
            let(:term) { partially_matching_renewal.last_name.chop }

            it "includes the partial match" do
              link_to_renewal = transient_registration_path(partially_matching_renewal.reg_identifier)

              get "/bo", term: term
              expect(response.body).to include(link_to_renewal)
            end
          end
        end
      end

      context "when the in_progress filter is on" do
        let(:in_progress_renewal) { create(:transient_registration) }
        let(:submitted_renewal) { create(:transient_registration, workflow_state: "renewal_received_form") }

        before do
          # Save first to get them to the top of the list and avoid pagination issues
          in_progress_renewal.save
          submitted_renewal.save

          get "/bo", in_progress: true
        end

        it "displays matching renewals" do
          link_to_renewal = transient_registration_path(in_progress_renewal.reg_identifier)
          expect(response.body).to include(link_to_renewal)
        end

        it "does not display non-matching renewals" do
          link_to_renewal = transient_registration_path(submitted_renewal.reg_identifier)
          expect(response.body).to_not include(link_to_renewal)
        end
      end

      context "when the pending_payment filter is on" do
        let(:pending_payment_renewal) { create(:transient_registration, :pending_payment) }
        let(:paid_renewal) { create(:transient_registration, :no_pending_payment) }

        before do
          # Save first to get them to the top of the list and avoid pagination issues
          pending_payment_renewal.save
          paid_renewal.save

          get "/bo", pending_payment: true
        end

        it "displays matching renewals" do
          link_to_renewal = transient_registration_path(pending_payment_renewal.reg_identifier)
          expect(response.body).to include(link_to_renewal)
        end

        it "does not display non-matching renewals" do
          link_to_renewal = transient_registration_path(paid_renewal.reg_identifier)
          expect(response.body).to_not include(link_to_renewal)
        end
      end

      context "when the pending_conviction_check filter is on" do
        let(:pending_conviction_check_renewal) { create(:transient_registration, :requires_conviction_check) }
        let(:no_conviction_check_renewal) { create(:transient_registration, :does_not_require_conviction_check) }

        before do
          # Save first to get them to the top of the list and avoid pagination issues
          pending_conviction_check_renewal.save
          no_conviction_check_renewal.save

          get "/bo", pending_conviction_check: true
        end

        it "displays matching renewals" do
          link_to_renewal = transient_registration_path(pending_conviction_check_renewal.reg_identifier)
          expect(response.body).to include(link_to_renewal)
        end

        it "does not display non-matching renewals" do
          link_to_renewal = transient_registration_path(no_conviction_check_renewal.reg_identifier)
          expect(response.body).to_not include(link_to_renewal)
        end
      end

      context "when multiple filters are on" do
        let(:matches_both_filters) { create(:transient_registration, :pending_payment, :requires_conviction_check) }
        let(:matches_one_filter) { create(:transient_registration, :no_pending_payment, :requires_conviction_check) }

        before do
          # Save first to get them to the top of the list and avoid pagination issues
          matches_both_filters.save
          matches_one_filter.save

          get "/bo", pending_conviction_check: true, pending_payment: true
        end

        it "displays renewals which match all the filters" do
          link_to_renewal = transient_registration_path(matches_both_filters.reg_identifier)
          expect(response.body).to include(link_to_renewal)
        end

        it "does not display renewals which only match one filter" do
          link_to_renewal = transient_registration_path(matches_one_filter.reg_identifier)
          expect(response.body).to_not include(link_to_renewal)
        end
      end

      context "when a search term and a filter are both present" do
        let(:term) { "Acme" }

        let(:matching_search_term_and_filter) { create(:transient_registration, :pending_payment, company_name: term) }
        let(:matching_search_term) { create(:transient_registration, :no_pending_payment, company_name: term) }
        let(:matching_filter) { create(:transient_registration, :pending_payment) }

        before do
          # Save first to get them to the top of the list and avoid pagination issues
          matching_search_term_and_filter.save
          matching_search_term.save
          matching_filter.save

          get "/bo", term: term, pending_payment: true
        end

        it "displays renewals which match the search term and filter" do
          link_to_renewal = transient_registration_path(matching_search_term_and_filter.reg_identifier)
          expect(response.body).to include(link_to_renewal)
        end

        it "does not display renewals which only match the search term" do
          link_to_renewal = transient_registration_path(matching_search_term.reg_identifier)
          expect(response.body).to_not include(link_to_renewal)
        end

        it "does not display renewals which only match the filter" do
          link_to_renewal = transient_registration_path(matching_filter.reg_identifier)
          expect(response.body).to_not include(link_to_renewal)
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
