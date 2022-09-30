# frozen_string_literal: true

require "rails_helper"

RSpec.describe "WorldpayEscapes", type: :request do
  let(:transient_registration) { create(:renewing_registration) }
  let(:_id) { transient_registration._id }

  describe "GET /bo/resources/:_id/revert-to-payment-summary" do
    let(:user) { create(:user) }

    before(:each) do
      sign_in(user)
    end

    context "when the user has the correct role" do
      let(:user) { create(:user, :agency) }

      context "when the workflow_state is worldpay_form" do
        before do
          transient_registration.update(workflow_state: "worldpay_form")
        end

        it "redirects to the payment_summary_form and updates the workflow_state" do
          get "/bo/resources/#{_id}/revert-to-payment-summary"

          expect(response).to redirect_to WasteCarriersEngine::Engine.routes.url_helpers.new_payment_summary_form_path(transient_registration.token)
          expect(transient_registration.reload.workflow_state).to eq("payment_summary_form")
        end
      end

      context "when the workflow_state is not worldpay_form" do
        before do
          transient_registration.update(workflow_state: "renewal_start_form")
        end

        context "when the resource is a renewal" do
          it "renders the renewing registration details page" do
            get "/bo/resources/#{_id}/revert-to-payment-summary"

            expect(response).to redirect_to renewing_registration_path(transient_registration.reg_identifier)
          end
        end

        context "when the resource is a new registration" do
          let(:transient_registration) { create(:new_registration) }

          it "renders the new registration details page" do
            get "/bo/resources/#{_id}/revert-to-payment-summary"

            expect(response).to redirect_to new_registration_path(transient_registration.token)
          end
        end
      end
    end

    context "when the user does not have the correct role" do
      let(:user) { create(:user, :finance) }

      it "renders the permissions error page" do
        get "/bo/resources/#{_id}/revert-to-payment-summary"

        expect(response).to redirect_to "/bo/pages/permission"
      end
    end
  end
end
