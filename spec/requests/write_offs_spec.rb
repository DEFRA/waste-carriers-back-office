# frozen_string_literal: true

require "rails_helper"

RSpec.describe "WriteOffs", type: :request do
  describe "GET /bo/finance_details/:_id/write_off/new" do
    context "when an agency user is signed in" do
      let(:user) { create(:user, :agency) }
      let(:renewing_registration) { create(:renewing_registration, :overpaid) }

      before(:each) do
        sign_in(user)
      end

      context "when the renewing registration has an overpayment below the agency user cap" do
        before do
          renewing_registration.finance_details.balance = -(WasteCarriersBackOffice::Application.config.write_off_agency_user_cap.to_i - 1)
          renewing_registration.save
        end

        it "renders the new template and returns a 200 status" do
          get new_finance_details_write_off_path(renewing_registration._id)

          expect(response).to render_template(:new)
          expect(response).to have_http_status(200)
        end
      end

      context "when the renewing registration has an overpayment above the agency user cap" do
        before do
          renewing_registration.finance_details.balance = -(WasteCarriersBackOffice::Application.config.write_off_agency_user_cap.to_i + 1)
        end

        it "redirects to the permissions page" do
          get new_finance_details_write_off_path(renewing_registration._id)

          expect(response).to redirect_to("/bo/pages/permission")
        end
      end
    end

    context "when an finance admin user is signed in" do
      let(:user) { create(:user, :finance_admin) }
      let(:renewing_registration) { create(:renewing_registration, :overpaid) }

      before(:each) do
        sign_in(user)
      end

      it "renders the new template and returns a 200 status" do
        get new_finance_details_write_off_path(renewing_registration._id)

        expect(response).to render_template(:new)
        expect(response).to have_http_status(200)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get new_finance_details_write_off_path("foo")

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /bo/finance_details/:_id/write_off" do
    context "when a finance admin user is signed in" do
      let(:user) { create(:user, :finance_admin) }
      let(:renewing_registration) { create(:renewing_registration, :overpaid) }

      before(:each) do
        sign_in(user)
      end

      context "when the request data are valid" do
        let(:params) do
          {
            write_off_form: {
              comment: "A comment"
            }
          }
        end

        it "returns a 302 status and redirects to the finance details page" do
          post finance_details_write_off_path(renewing_registration._id), params

          expect(response).to have_http_status(302)
          expect(response).to redirect_to(finance_details_path(renewing_registration._id))
        end
      end

      context "when the request data are not valid" do
        it "returns a 200 status and renders the :new template" do
          post finance_details_write_off_path(renewing_registration._id), {}

          expect(response).to have_http_status(200)
          expect(response).to render_template(:new)
        end
      end
    end
  end
end
