# frozen_string_literal: true

require "rails_helper"

RSpec.describe "MissedCardPaymentNewRegistrations" do
  let(:transient_registration) { create(:new_registration, :has_required_data) }
  let(:_id) { transient_registration._id }

  describe "GET /bo/resources/:_id/missed-card-payment-new-registration" do
    let(:user) { create(:user) }

    before do
      sign_in(user)
    end

    context "when the user has the correct role" do
      let(:user) { create(:user, role: :finance_admin) }

      context "when the workflow_state is govpay_form" do
        before do
          transient_registration.update(workflow_state: "govpay_form")
        end

        it "creates a new registration and redirects to the 'add missed payment' form" do
          old_registration_count = WasteCarriersEngine::Registration.count
          old_new_registration_count = WasteCarriersEngine::NewRegistration.count
          expected_reg_identifier = transient_registration.reg_identifier

          get "/bo/resources/#{_id}/missed-card-payment-new-registration"

          expect(WasteCarriersEngine::Registration.count).to eq(old_registration_count + 1)
          expect(WasteCarriersEngine::NewRegistration.count).to eq(old_new_registration_count - 1)

          registration = WasteCarriersEngine::Registration.where(reg_identifier: expected_reg_identifier).first
          expect(response).to redirect_to new_resource_missed_card_payment_form_path(registration._id)
        end
      end

      context "when the workflow_state is not govpay_form" do
        before do
          transient_registration.update(workflow_state: "payment_summary_form")
        end

        it "renders the new registration details page" do
          get "/bo/resources/#{_id}/missed-card-payment-new-registration"

          expect(response).to redirect_to new_registration_path(transient_registration.token)
        end
      end
    end

    context "when the user does not have the correct role" do
      let(:user) { create(:user, role: :agency) }

      it "renders the permissions error page" do
        get "/bo/resources/#{_id}/missed-card-payment-new-registration"

        expect(response).to redirect_to "/bo/pages/permission"
      end
    end
  end
end
