# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Refunds" do
  describe "GET /bo/resources/:_id/refunds" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency_with_refund) }
      let(:renewing_registration) { create(:renewing_registration, :overpaid) }
      let(:worldpay_payment) { renewing_registration.finance_details.payments.select { |p| p.payment_type == "WORLDPAY" }.first }
      let(:govpay_payment) { renewing_registration.finance_details.payments.select { |p| p.payment_type == "GOVPAY" }.first }
      let(:govpay_active?) { false }

      before do
        # Ensure the registration has both govpay and worldpay payments
        renewing_registration.finance_details.payments << build(:payment, :govpay)
        renewing_registration.save!

        sign_in(user)

        get resource_refunds_path(renewing_registration._id)
      end

      it "renders the index template and returns a 200 status" do
        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
      end

      it "lists only govpay payments" do
        expect(response.body).to match(/#{govpay_payment.order_key}/)
        expect(response.body).not_to match(/#{worldpay_payment.order_key}/)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get resource_refunds_path("foo")

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /bo/resource/:_id/refunds/new" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency_with_refund) }
      let(:renewing_registration) { create(:renewing_registration, :overpaid) }
      let(:payment) { renewing_registration.finance_details.payments.first }

      before do
        sign_in(user)
      end

      it "renders the index template and returns a 200 status" do
        get new_resource_refund_path(renewing_registration._id, order_key: payment.order_key)

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get new_resource_refund_path("foo", order_key: "bar")

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /bo/resource/:_id/refunds/:order_key" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency_with_refund) }
      let(:payment) { renewing_registration.finance_details.payments.first }

      before do
        renewing_registration.finance_details.orders.first.order_code = payment.order_key
        renewing_registration.save

        sign_in(user)
      end

      context "when the payment is a govpay payment" do
        let(:renewing_registration) { create(:renewing_registration, :overpaid_govpay) }
        let(:govpay_refund_response) { Rails.root.join("spec/fixtures/files/govpay/get_refund_response_submitted.json").read }

        before do
          allow(GovpayRefundService).to receive(:run).and_return(govpay_refund_response)
        end

        it "creates a refund payment, redirects to the finance details page and returns a 302 status" do
          expected_payments_count = renewing_registration.finance_details.payments.count + 1

          post resource_refunds_path(renewing_registration._id), params: { order_key: payment.order_key }

          renewing_registration.reload
          expect(renewing_registration.finance_details.payments.count).to eq(expected_payments_count)

          expect(response).to redirect_to(resource_finance_details_path(renewing_registration._id))
          expect(response).to have_http_status(:found)
        end
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        post resource_refunds_path("foo"), params: { order_key: "bar" }

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when a user with the wrong permissions is signed in" do
      it "redirects to the permissions page" do
        sign_in(create(:user))

        post resource_refunds_path("foo"), params: { order_key: "bar" }

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end
  end

  describe "PATCH /bo/resources/:_id/refunds" do

    let(:registration) { create(:registration, :overpaid) }
    let(:refund) { build(:payment, :govpay_refund_pending) }

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        patch resource_refund_path(registration, refund.id)

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency_with_refund) }
      let(:update_service) { instance_double(GovpayUpdateRefundStatusService) }

      before do
        registration.finance_details.payments << refund

        allow(GovpayUpdateRefundStatusService).to receive(:new).and_return(update_service)
        allow(update_service).to receive(:run)

        sign_in(user)

        patch resource_refund_path(registration, refund.id)
      end

      it "calls the refund update service" do
        expect(update_service).to have_received(:run)
      end

      it "redirects to the finance-details page" do
        expect(response).to redirect_to resource_finance_details_path(registration)
      end
    end
  end
end
