# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Payment method confirmation forms" do
  describe "/bo/:token/payment-method-confirmation" do
    let(:user) { create(:user, role: :agency_super) }
    let(:transient_registration) { create(:new_registration, workflow_state: "payment_method_confirmation_form") }
    let(:path) { "/bo/#{transient_registration.token}/payment-method-confirmation" }

    before { sign_in(user) }

    it "returns http success" do
      get path

      expect(response).to have_http_status(:success)
    end
  end
end
