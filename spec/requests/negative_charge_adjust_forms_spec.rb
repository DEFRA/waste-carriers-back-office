# frozen_string_literal: true

require "rails_helper"

RSpec.describe "NegativeChargeAdjustForms" do
  describe "GET /bo/resource/:_id/charge-adjust/negative" do
    context "when a finance super user is signed in" do
      let(:user) { create(:user, role: :finance_super) }
      let(:renewing_registration) { create(:renewing_registration) }

      before do
        sign_in(user)
      end

      it "renders the new template and returns a 200 status" do
        get new_resource_negative_charge_adjust_form_path(renewing_registration._id)

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when a non finance super user is signed in" do
      let(:user) { create(:user) }
      let(:renewing_registration) { create(:renewing_registration) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions page" do
        get new_resource_negative_charge_adjust_form_path(renewing_registration._id)

        expect(response).to redirect_to("/bo/pages/permission")
        expect(response).to have_http_status(:found)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get new_resource_negative_charge_adjust_form_path("foo")

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /bo/resource/:_id/charge-adjust/negative" do
    context "when a finance super user is signed in" do
      let(:user) { create(:user, role: :finance_super) }
      let(:renewing_registration) { create(:renewing_registration) }

      before do
        sign_in(user)
      end

      context "when the request data are valid" do
        let(:params) do
          {
            negative_charge_adjust_form: {
              amount: 100,
              reference: "Reference",
              description: "Description"
            }
          }
        end

        it "generates a new order and redirects to the finance details page with a 302" do
          expected_orders_count = renewing_registration.finance_details.orders.count + 1

          post resource_negative_charge_adjust_form_path(renewing_registration._id), params: params

          renewing_registration.reload

          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(resource_finance_details_path(renewing_registration._id))
          expect(renewing_registration.finance_details.orders.count).to eq(expected_orders_count)
        end

        context "when the charge adjust clears the resource balance and the resource is in a renewable status" do
          let(:renewing_registration) { create(:renewing_registration, :pending_payment) }
          let(:params) do
            {
              negative_charge_adjust_form: {
                amount: (renewing_registration.finance_details.balance.to_f / 100).to_s,
                reference: "Reference",
                description: "Description"
              }
            }
          end

          it "generates a new order and redirects to the registration finance details page with a 302" do
            registration = renewing_registration.registration
            previous_orders_count = registration.finance_details.orders.count

            post resource_negative_charge_adjust_form_path(renewing_registration._id), params: params

            registration.reload

            expect(response).to have_http_status(:found)
            expect(response).to redirect_to(resource_finance_details_path(registration._id))
            expect(registration.finance_details.orders.count).to be > previous_orders_count
          end
        end
      end

      context "when the request data are not valid" do
        it "returns a 200 status and renders the :new template" do
          post resource_negative_charge_adjust_form_path(renewing_registration._id), params: {}

          expect(response).to have_http_status(:ok)
          expect(response).to render_template(:new)
        end
      end
    end
  end
end
