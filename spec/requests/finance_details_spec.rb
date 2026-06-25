# frozen_string_literal: true

require "rails_helper"

RSpec.describe "FinanceDetails" do
  describe "GET /bo/resource/:_id/finance-details" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      context "when the registration is a transient object" do
        let(:renewing_registration) { create(:renewing_registration, :has_finance_details) }

        it "renders the show template and returns a 200 status" do
          get resource_finance_details_path(renewing_registration._id)

          expect(response).to render_template(:show)
          expect(response).to have_http_status(:ok)
        end

        context "when it has a mix of successful and unsuccessful card payments" do
          let(:finance_details) do
            build(:finance_details).tap do |details|
              details.orders = [build(:order, :has_required_data)]
              details.payments = [
                build(
                  :payment,
                  :govpay,
                  order_key: "successful-govpay",
                  govpay_payment_status: WasteCarriersEngine::Payment::STATUS_SUCCESS
                ),
                build(
                  :payment,
                  :govpay,
                  order_key: "started-govpay",
                  govpay_payment_status: WasteCarriersEngine::Payment::STATUS_STARTED
                ),
                build(
                  :payment,
                  :worldpay,
                  order_key: "authorised-worldpay",
                  world_pay_payment_status: WasteCarriersEngine::Payment::STATUS_AUTHORISED
                ),
                build(
                  :payment,
                  :worldpay,
                  order_key: "refused-worldpay",
                  world_pay_payment_status: WasteCarriersEngine::Payment::STATUS_REFUSED
                ),
                build(:payment, :bank_transfer, order_key: "bank-transfer")
              ]
              details.update_balance
            end
          end
          let(:renewing_registration) { create(:renewing_registration, finance_details:) }

          it "shows only successful card payments in the payment history" do
            get resource_finance_details_path(renewing_registration._id)

            expect(response.body).to include("successful-govpay")
            expect(response.body).to include("authorised-worldpay")
            expect(response.body).to include("bank-transfer")
            expect(response.body).not_to include("started-govpay")
            expect(response.body).not_to include("refused-worldpay")
          end
        end
      end

      context "when the registration is not a transient object" do
        let(:registration) { create(:registration, :has_orders_and_payments) }

        it "renders the show template and returns a 200 status" do
          get resource_finance_details_path(registration._id)

          expect(response).to render_template(:show)
          expect(response).to have_http_status(:ok)
        end
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get resource_finance_details_path("doo")

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
