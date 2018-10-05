# frozen_string_literal: true

require "rails_helper"

RSpec.describe "WorldpayEscapes", type: :request do
  let(:transient_registration) { create(:transient_registration, workflow_state: "worldpay_form") }

  describe "GET /bo/transient-registrations/:reg_identifier/revert-to-payment-summary" do
    let(:user) { create(:user) }
    before(:each) do
      sign_in(user)
    end

    it "redirects" do
      get "/bo/transient-registrations/#{transient_registration.reg_identifier}/revert-to-payment-summary"
      expect(response.code).to eq("302")
    end
  end
end
