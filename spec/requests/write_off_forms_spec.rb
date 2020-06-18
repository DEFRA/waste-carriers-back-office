# frozen_string_literal: true

require "rails_helper"

RSpec.describe "WriteOffForms", type: :request do
  describe "GET /bo/resource/:_id/write-off/new" do
    context "when an agency user is signed in" do
      let(:user) { create(:user, :agency_with_refund) }
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
          get new_resource_write_off_form_path(renewing_registration._id)

          expect(response).to render_template(:new)
          expect(response).to have_http_status(200)
        end
      end

      context "when the renewing registration has an overpayment above the agency user cap" do
        before do
          renewing_registration.finance_details.balance = -(WasteCarriersBackOffice::Application.config.write_off_agency_user_cap.to_i + 1)
        end

        it "redirects to the permissions page" do
          get new_resource_write_off_form_path(renewing_registration._id)

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
        get new_resource_write_off_form_path(renewing_registration._id)

        expect(response).to render_template(:new)
        expect(response).to have_http_status(200)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get new_resource_write_off_form_path("foo")

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /bo/resource/:_id/write-off" do
    context "when a finance admin user is signed in" do
      let(:user) { create(:user, :finance_admin) }
      let(:renewing_registration) { create(:renewing_registration, :overpaid, workflow_state: :renewal_received_pending_payment_form) }

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

        context "when the resource is a registration" do
          let(:registration) { create(:registration, :has_unpaid_order, :pending) }

          it "activates the registration" do
            post resource_write_off_form_path(registration._id), params: params

            registration.reload

            expect(registration.finance_details.balance).to eq(0)
            expect(registration).to be_active
          end
        end

        it "generates a new payment, renews the registration, updates the registration balance, returns a 302 status and redirects to the finance details page" do
          registration = renewing_registration.registration
          before_request_payments_count = registration.finance_details.payments.count

          post resource_write_off_form_path(renewing_registration._id), params: params

          transient_registrations_count = WasteCarriersEngine::RenewingRegistration.where(reg_identifier: renewing_registration.reg_identifier).count
          registration.reload

          expect(transient_registrations_count).to eq(0)
          expect(registration.finance_details.payments.count).to be > before_request_payments_count
          expect(registration.finance_details.balance).to eq(0)
          expect(response).to have_http_status(302)
          expect(response).to redirect_to(resource_finance_details_path(registration._id))
        end

        context "when the resource is a registration" do
          let(:registration) { create(:registration, :overpaid) }

          it "generates a new payment, updates the registration balance, returns a 302 status and redirects to the registration finance details page" do
            before_request_payments_count = registration.finance_details.payments.count

            post resource_write_off_form_path(registration._id), params: params

            registration.reload

            expect(registration.finance_details.payments.count).to be > before_request_payments_count
            expect(registration.finance_details.balance).to eq(0)
            expect(response).to have_http_status(302)
            expect(response).to redirect_to(resource_finance_details_path(registration._id))
          end
        end
      end

      context "when the request data are not valid" do
        it "returns a 200 status and renders the :new template" do
          post resource_write_off_form_path(renewing_registration._id), params: {}

          expect(response).to have_http_status(200)
          expect(response).to render_template(:new)
        end
      end
    end
  end
end
