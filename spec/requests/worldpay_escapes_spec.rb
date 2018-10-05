# frozen_string_literal: true

require "rails_helper"

RSpec.describe "WorldpayEscapes", type: :request do
  let(:transient_registration) { create(:transient_registration) }
  let(:reg_identifier) { transient_registration.reg_identifier }

  describe "GET /bo/transient-registrations/:reg_identifier/revert-to-payment-summary" do
    let(:user) { create(:user) }
    before(:each) do
      sign_in(user)
    end

    context "when the workflow_state is worldpay_form" do
      before do
        transient_registration.update_attributes(workflow_state: "worldpay_form")
      end

      it "redirects to the payment_summary_form" do
        get "/bo/transient-registrations/#{reg_identifier}/revert-to-payment-summary"
        expect(response).to redirect_to WasteCarriersEngine::Engine.routes.url_helpers.new_payment_summary_form_path(reg_identifier)
      end
    end

    context "when the workflow_state is not worldpay_form" do
      before do
        transient_registration.update_attributes(workflow_state: "renewal_start_form")
      end

      it "renders the transient_registration page" do
        get "/bo/transient-registrations/#{reg_identifier}/revert-to-payment-summary"
        expect(response).to redirect_to transient_registration_path(reg_identifier)
      end
    end
  end
end
