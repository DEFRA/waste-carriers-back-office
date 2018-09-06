# frozen_string_literal: true

require "rails_helper"

RSpec.describe "WorldpayMissedPaymentForms", type: :request do
  let(:transient_registration) { create(:transient_registration, :has_finance_details) }

  describe "GET /bo/transient-registrations/:reg_identifier/payments/worldpay-missed" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :finance_admin) }
      before(:each) do
        sign_in(user)
      end

      it "renders the new template" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/worldpay-missed"
        expect(response).to render_template(:new)
      end

      it "returns a 200 response" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/worldpay-missed"
        expect(response).to have_http_status(200)
      end

      it "includes the reg identifier" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/worldpay-missed"
        expect(response.body).to include(transient_registration.reg_identifier)
      end
    end

    context "when a non-finance_admin user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/worldpay-missed"
        expect(response).to redirect_to("/bo/permission")
      end
    end
  end

  describe "POST /bo/transient-registrations/:reg_identifier/payments/worldpay-missed" do
    let(:params) do
      {
        reg_identifier: transient_registration.reg_identifier,
        amount: "100",
        comment: "foo",
        registration_reference: "foo",
        date_received_day: "1",
        date_received_month: "1",
        date_received_year: "2018"
      }
    end

    context "when a valid user is signed in" do
      let(:user) { create(:user, :finance_admin) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the transient_registration page" do
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/worldpay-missed", worldpay_missed_payment_form: params
        expect(response).to redirect_to(transient_registration_path(transient_registration.reg_identifier))
      end

      it "creates a new payment" do
        old_payments_count = transient_registration.finance_details.payments.count
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/worldpay-missed", worldpay_missed_payment_form: params
        expect(transient_registration.reload.finance_details.payments.count).to eq(old_payments_count + 1)
      end

      it "assigns the correct updated_by_user to the payment" do
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/worldpay-missed", worldpay_missed_payment_form: params
        expect(transient_registration.reload.finance_details.payments.first.updated_by_user).to eq(user.email)
      end

      context "when the params are invalid" do
        let(:params) do
          {
            reg_identifier: transient_registration.reg_identifier,
            revoked_reason: ""
          }
        end

        it "renders the new template" do
          post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/worldpay-missed", worldpay_missed_payment_form: params
          expect(response).to render_template(:new)
        end

        it "does not create a new payment" do
          old_payments_count = transient_registration.finance_details.payments.count
          post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/worldpay-missed", worldpay_missed_payment_form: params
          expect(transient_registration.reload.finance_details.payments.count).to eq(old_payments_count)
        end
      end
    end

    context "when a non-finance_admin user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/worldpay-missed", worldpay_missed_payment_form: params
        expect(response).to redirect_to("/bo/permission")
      end

      it "does not create a new payment" do
        old_payments_count = transient_registration.finance_details.payments.count
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/worldpay-missed", worldpay_missed_payment_form: params
        expect(transient_registration.reload.finance_details.payments.count).to eq(old_payments_count)
      end
    end
  end
end
