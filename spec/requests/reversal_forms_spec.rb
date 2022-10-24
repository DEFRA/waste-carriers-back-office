# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ReversalForms", type: :request do
  describe "GET /bo/resources/:_id/reversals" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency_with_refund) }
      let(:renewing_registration) { create(:renewing_registration, :overpaid) }

      before(:each) do
        sign_in(user)
      end

      it "renders the index template and returns a 200 status" do
        get resource_reversal_forms_path(renewing_registration._id)

        expect(response).to render_template(:index)
        expect(response).to have_http_status(200)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get resource_reversal_forms_path("foo")

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /bo/resource/:_id/reversals/:order_key/new" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency_with_refund) }
      let(:renewing_registration) { create(:renewing_registration, :overpaid) }
      let(:payment) { renewing_registration.finance_details.payments.first }

      before(:each) do
        sign_in(user)

        payment.payment_type = "CASH"
        payment.save
      end

      it "renders the index template and returns a 200 status" do
        get new_resource_reversal_form_path(renewing_registration._id, order_key: payment.order_key)

        expect(response).to render_template(:new)
        expect(response).to have_http_status(200)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get new_resource_reversal_form_path("foo", order_key: "foo")

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /bo/resource/:_id/reversals/:order_key" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency_with_refund) }
      let(:renewing_registration) { create(:renewing_registration, :overpaid) }
      let(:payment) { renewing_registration.finance_details.payments.first }

      before(:each) do
        sign_in(user)

        payment.payment_type = WasteCarriersEngine::Payment::CASH
        payment.save
      end

      context "when params are valid" do
        let(:params) do
          {
            reversal_form: {
              reason: "A reason."
            }
          }
        end

        it "creates a reversal payment, redirects to the finance details page and returns a 302 status" do
          expected_payments_count = renewing_registration.finance_details.payments.count + 1

          post resource_reversal_forms_path(renewing_registration._id, order_key: payment.order_key), params: params

          renewing_registration.reload
          expect(renewing_registration.finance_details.payments.count).to eq(expected_payments_count)

          expect(response).to redirect_to(resource_finance_details_path(renewing_registration._id))
          expect(response).to have_http_status(302)
        end
      end

      context "when params are not valid" do
        it "does not create a reversal payment, renders the new template and returns a 200 status code" do
          expected_payments_count = renewing_registration.finance_details.payments.count

          post resource_reversal_forms_path(renewing_registration._id, order_key: payment.order_key), params: {}

          renewing_registration.reload
          expect(renewing_registration.finance_details.payments.count).to eq(expected_payments_count)

          expect(response).to render_template(:new)
          expect(response).to have_http_status(200)
        end
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        post resource_reversal_forms_path("foo", order_key: "bar")

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when a user with the wrong permissions is signed in" do
      let(:renewing_registration) { create(:renewing_registration, :overpaid) }

      it "redirects to the permissions page" do
        sign_in(create(:user))

        post resource_reversal_forms_path(renewing_registration._id, order_key: "bar")

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end
  end
end
