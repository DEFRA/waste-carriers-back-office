# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PositiveChargeAdjustForms", type: :request do
  describe "GET /bo/resource/:_id/charge-adjust/positive" do
    context "when a finance super user is signed in" do
      let(:user) { create(:user, :finance_super) }
      let(:renewing_registration) { create(:renewing_registration) }

      before(:each) do
        sign_in(user)
      end

      it "renders the new template and returns a 200 status" do
        get new_resource_positive_charge_adjust_form_path(renewing_registration._id)

        expect(response).to render_template(:new)
        expect(response).to have_http_status(200)
      end
    end

    context "when a non finance super user is signed in" do
      let(:user) { create(:user) }
      let(:renewing_registration) { create(:renewing_registration) }

      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions page" do
        get new_resource_positive_charge_adjust_form_path(renewing_registration._id)

        expect(response).to redirect_to("/bo/pages/permission")
        expect(response).to have_http_status(302)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get new_resource_positive_charge_adjust_form_path("foo")

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /bo/resource/:_id/charge-adjust/positive" do
    context "when a finance super user is signed in" do
      let(:user) { create(:user, :finance_super) }
      let(:renewing_registration) { create(:renewing_registration) }

      before(:each) do
        sign_in(user)
      end

      context "when the request data are valid" do
        let(:params) do
          {
            positive_charge_adjust_form: {
              amount: 100,
              reference: "Reference",
              description: "Description"
            }
          }
        end

        it "generates a new order and redirects to the finance details page with a 302" do
          expected_orders_count = renewing_registration.finance_details.orders.count + 1

          post resource_positive_charge_adjust_form_path(renewing_registration._id), params

          renewing_registration.reload

          expect(response).to have_http_status(302)
          expect(response).to redirect_to(resource_finance_details_path(renewing_registration._id))
          expect(renewing_registration.finance_details.orders.count).to eq(expected_orders_count)
        end
      end

      context "when the request data are not valid" do
        it "returns a 200 status and renders the :new template" do
          post resource_positive_charge_adjust_form_path(renewing_registration._id), {}

          expect(response).to have_http_status(200)
          expect(response).to render_template(:new)
        end
      end
    end
  end
end
