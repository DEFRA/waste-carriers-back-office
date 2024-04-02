# frozen_string_literal: true

require "rails_helper"

RSpec.describe "BankTransferPaymentForms" do
  let(:transient_registration) do
    create(:renewing_registration, :has_finance_details, :does_not_require_conviction_check)
  end
  let(:registration) { transient_registration.registration }

  describe "GET /bo/resources/:_id/payments/bank-transfer" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :finance) }

      before do
        sign_in(user)
      end

      it "renders the new template, returns a 200 response and includes the reg identifier" do
        get "/bo/resources/#{transient_registration._id}/payments/bank-transfer"

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(transient_registration.reg_identifier)
      end

      context "when the resource is a registration" do
        let(:registration) { create(:registration) }

        it "renders the new template, returns a 200 response and includes the reg identifier" do
          get "/bo/resources/#{registration._id}/payments/bank-transfer"

          expect(response).to render_template(:new)
          expect(response).to have_http_status(:ok)
          expect(response.body).to include(registration.reg_identifier)
        end
      end
    end

    context "when a non-finance user is signed in" do
      let(:user) { create(:user, role: :agency) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/resources/#{transient_registration._id}/payments/bank-transfer"

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end
  end

  describe "POST /bo/resources/:_id/payments/bank-transfer" do
    let(:params) do
      {
        amount: transient_registration.finance_details.balance,
        comment: "foo",
        registration_reference: "foo",
        date_received_day: "1",
        date_received_month: "1",
        date_received_year: "2018"
      }
    end

    context "when a valid user is signed in" do
      let(:user) { create(:user, role: :finance) }

      before do
        # ensure the payment amount is non-zero
        transient_registration.finance_details.update(balance: 1)

        sign_in(user)
      end

      context "when there is no pending conviction check" do
        it "renews the transient registration, redirects to the registration finance page, creates a new payment and assigns the correct updated_by_user to the payment" do
          old_payments_count = registration.finance_details.payments.count
          expected_expiry_date = registration.expires_on.to_date + 3.years

          post "/bo/resources/#{transient_registration._id}/payments/bank-transfer", params: { bank_transfer_payment_form: params }

          registration.reload
          actual_expiry_date = registration.expires_on.to_date

          expect(response).to redirect_to(resource_finance_details_path(registration._id))
          expect(registration.finance_details.payments.count).to be > old_payments_count
          expect(registration.finance_details.payments.last.updated_by_user).to eq(user.email)
          expect(actual_expiry_date).to eq(expected_expiry_date)
        end

        context "when the resource is a registration" do
          let(:registration) { create(:registration, :pending, :has_unpaid_order) }
          let(:params) do
            {
              amount: "110.00",
              comment: "foo",
              registration_reference: "foo",
              date_received_day: "1",
              date_received_month: "1",
              date_received_year: "2018"
            }
          end

          it "completes the registration, redirects to the registration finance page and creates a new payment" do
            old_payments_count = registration.finance_details.payments.count

            post "/bo/resources/#{registration._id}/payments/bank-transfer", params: { bank_transfer_payment_form: params }

            registration.reload

            expect(response).to redirect_to(resource_finance_details_path(registration._id))
            expect(registration.finance_details.payments.count).to be > old_payments_count
            expect(registration).to be_active
          end
        end
      end

      context "when there is a pending conviction check" do
        before { transient_registration.conviction_sign_offs = [build(:conviction_sign_off)] }

        it "does not renews the registration" do
          old_renewal_date = registration.expires_on

          post "/bo/resources/#{transient_registration._id}/payments/bank-transfer", params: { bank_transfer_payment_form: params }

          expect(registration.reload.expires_on).to eq(old_renewal_date)
        end

        context "when the resource is a registration" do
          let(:registration) { create(:registration, :pending, :has_unpaid_order, :requires_conviction_check) }
          let(:params) do
            {
              amount: registration.finance_details.balance,
              comment: "foo",
              registration_reference: "foo",
              date_received_day: "1",
              date_received_month: "1",
              date_received_year: "2018"
            }
          end

          it "does not completes the registration" do
            post "/bo/resources/#{transient_registration._id}/payments/bank-transfer", params: { bank_transfer_payment_form: params }

            registration.reload

            expect(registration).not_to be_active
          end
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

          post "/bo/resources/#{transient_registration._id}/payments/bank-transfer", params: { bank_transfer_payment_form: params }

          expect(response).to render_template(:new)
          expect(transient_registration.reload.finance_details.payments.count).to eq(old_payments_count)
        end
      end
    end

    context "when a non-finance user is signed in" do
      let(:user) { create(:user, role: :agency) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page and does not create a new payment" do
        old_payments_count = transient_registration.finance_details.payments.count

        post "/bo/resources/#{transient_registration._id}/payments/bank-transfer", params: { bank_transfer_payment_form: params }

        expect(response).to redirect_to("/bo/pages/permission")
        expect(transient_registration.reload.finance_details.payments.count).to eq(old_payments_count)
      end
    end
  end
end
