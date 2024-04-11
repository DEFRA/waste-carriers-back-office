# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ChequePaymentForms" do
  let(:transient_registration) do
    create(:renewing_registration, :does_not_require_conviction_check)
  end

  let(:registration) do
    WasteCarriersEngine::Registration.where(reg_identifier: transient_registration.reg_identifier).first
  end

  describe "GET /bo/resource/:_id/payments/cheque" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency_with_refund) }

      before do
        sign_in(user)
      end

      it "renders the new template, rerturns aa 200 rersponse and includes the reg identifier" do
        get "/bo/resources/#{transient_registration._id}/payments/cheque"

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(transient_registration.reg_identifier)
      end

      context "when the resource is a registration" do
        let(:registration) { create(:registration) }

        it "renders the new template, rerturns aa 200 rersponse and includes the reg identifier" do
          get "/bo/resources/#{registration._id}/payments/cheque"

          expect(response).to render_template(:new)
          expect(response).to have_http_status(:ok)
          expect(response.body).to include(registration.reg_identifier)
        end
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, role: :finance) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/resources/#{transient_registration._id}/payments/cheque"

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end
  end

  describe "POST /bo/transient-registrations/:reg_identifier/payments/cheque" do
    let(:params) do
      {
        amount: "102.00",
        comment: "foo",
        registration_reference: "foo",
        date_received_day: "1",
        date_received_month: "1",
        date_received_year: "2018"
      }
    end
    let(:renewal_completion_service) { WasteCarriersEngine::RenewalCompletionService.new(transient_registration) }

    before do
      allow(WasteCarriersEngine::RenewalCompletionService).to receive(:new).and_return(renewal_completion_service)

      # Block deletion so we can check the values of the transient_registration after submission
      allow(renewal_completion_service).to receive(:delete_transient_registration)
    end

    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :agency_with_refund) }

      before do
        sign_in(user)
      end

      it "redirects to the registration finance page, creates a new payment and assigns the correct user to it" do
        registration = transient_registration.registration
        old_payments_count = transient_registration.finance_details.payments.count

        post "/bo/resources/#{transient_registration._id}/payments/cheque", params: { cheque_payment_form: params }

        expect(response).to redirect_to(resource_finance_details_path(registration._id))
        expect(transient_registration.reload.finance_details.payments.count).to eq(old_payments_count + 1)
        expect(transient_registration.reload.finance_details.payments.last.updated_by_user).to eq(user.email)
      end

      context "when there is no pending conviction check" do
        before { transient_registration.conviction_sign_offs = [build(:conviction_sign_off, :confirmed)] }

        it "renews the registration" do
          expected_expiry_date = registration.expires_on.to_date + 3.years

          post "/bo/resources/#{transient_registration._id}/payments/cheque", params: { cheque_payment_form: params }

          actual_expiry_date = registration.reload.expires_on.to_date

          expect(actual_expiry_date).to eq(expected_expiry_date)
        end
      end

      context "when there is a pending conviction check" do
        before { transient_registration.conviction_sign_offs = [build(:conviction_sign_off)] }

        it "does not renews the registration" do
          old_renewal_date = registration.expires_on

          post "/bo/resources/#{transient_registration._id}/payments/cheque", params: { cheque_payment_form: params }

          expect(registration.reload.expires_on).to eq(old_renewal_date)
        end
      end

      context "when the params are invalid" do
        let(:params) do
          {
            revoked_reason: ""
          }
        end

        it "renders the new template and does not create a new payment" do
          old_payments_count = transient_registration.finance_details.payments.count

          post "/bo/resources/#{transient_registration._id}/payments/cheque", params: { cheque_payment_form: params }

          expect(response).to render_template(:new)
          expect(transient_registration.reload.finance_details.payments.count).to eq(old_payments_count)
        end
      end
    end

    context "when a non-agency user is signed in" do
      let(:user) { create(:user, role: :finance) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page and does not create a new payment" do
        old_payments_count = transient_registration.finance_details.payments.count

        post "/bo/resources/#{transient_registration._id}/payments/cheque", params: { cheque_payment_form: params }

        expect(response).to redirect_to("/bo/pages/permission")
        expect(transient_registration.reload.finance_details.payments.count).to eq(old_payments_count)
      end
    end
  end
end
