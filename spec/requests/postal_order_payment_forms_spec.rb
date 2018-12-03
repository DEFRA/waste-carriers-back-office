# frozen_string_literal: true

require "rails_helper"

RSpec.describe "PostalOrderPaymentForms", type: :request do
  let(:transient_registration) do
    create(:transient_registration, :has_finance_details, :does_not_require_conviction_check)
  end
  let(:registration) do
    WasteCarriersEngine::Registration.where(reg_identifier: transient_registration.reg_identifier).first
  end

  describe "GET /bo/transient-registrations/:reg_identifier/payments/postal-order" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "renders the new template" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/postal-order"
        expect(response).to render_template(:new)
      end

      it "returns a 200 response" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/postal-order"
        expect(response).to have_http_status(200)
      end

      it "includes the reg identifier" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/postal-order"
        expect(response.body).to include(transient_registration.reg_identifier)
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, :finance) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/postal-order"
        expect(response).to redirect_to("/bo/permission")
      end
    end
  end

  describe "POST /bo/transient-registrations/:reg_identifier/payments/postal-order" do
    let(:params) do
      {
        reg_identifier: transient_registration.reg_identifier,
        amount: transient_registration.finance_details.balance,
        comment: "foo",
        registration_reference: "foo",
        date_received_day: "1",
        date_received_month: "1",
        date_received_year: "2018"
      }
    end

    before do
      # Block renewal completion so we can check the values of the transient_registration after submission
      allow_any_instance_of(WasteCarriersEngine::RenewalCompletionService).to receive(:complete_renewal).and_return(nil)
    end

    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the transient_registration page" do
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/postal-order", postal_order_payment_form: params
        expect(response).to redirect_to(transient_registration_path(transient_registration.reg_identifier))
      end

      it "creates a new payment" do
        old_payments_count = transient_registration.finance_details.payments.count
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/postal-order", postal_order_payment_form: params
        expect(transient_registration.reload.finance_details.payments.count).to eq(old_payments_count + 1)
      end

      it "assigns the correct updated_by_user to the payment" do
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/postal-order", postal_order_payment_form: params
        expect(transient_registration.reload.finance_details.payments.first.updated_by_user).to eq(user.email)
      end

      context "when there is no pending conviction check" do
        before do
          transient_registration.conviction_sign_offs = [build(:conviction_sign_off, :confirmed)]
          # Disable the stubbing as we want to test the full behaviour this time
          allow_any_instance_of(WasteCarriersEngine::RenewalCompletionService).to receive(:complete_renewal).and_call_original
        end

        it "renews the registration" do
          expected_expiry_date = registration.expires_on.to_date + 3.years
          post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/postal-order", postal_order_payment_form: params
          actual_expiry_date = registration.reload.expires_on.to_date

          expect(actual_expiry_date).to eq(expected_expiry_date)
        end
      end

      context "when there is a pending conviction check" do
        before do
          transient_registration.conviction_sign_offs = [build(:conviction_sign_off)]
          # Disable the stubbing as we want to test the full behaviour this time
          allow_any_instance_of(WasteCarriersEngine::RenewalCompletionService).to receive(:complete_renewal).and_call_original
        end

        it "does not renews the registration" do
          old_renewal_date = registration.expires_on
          post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/postal-order", postal_order_payment_form: params
          expect(registration.reload.expires_on).to eq(old_renewal_date)
        end
      end

      context "when the params are invalid" do
        let(:params) do
          {
            reg_identifier: transient_registration.reg_identifier,
            revoked_reason: ""
          }
        end

        it "renders the new template" do
          post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/postal-order", postal_order_payment_form: params
          expect(response).to render_template(:new)
        end

        it "does not create a new payment" do
          old_payments_count = transient_registration.finance_details.payments.count
          post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/postal-order", postal_order_payment_form: params
          expect(transient_registration.reload.finance_details.payments.count).to eq(old_payments_count)
        end
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, :finance) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/postal-order", postal_order_payment_form: params
        expect(response).to redirect_to("/bo/permission")
      end

      it "does not create a new payment" do
        old_payments_count = transient_registration.finance_details.payments.count
        post "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments/postal-order", postal_order_payment_form: params
        expect(transient_registration.reload.finance_details.payments.count).to eq(old_payments_count)
      end
    end
  end
end
