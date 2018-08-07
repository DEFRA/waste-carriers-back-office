# frozen_string_literal: true

require "rails_helper"

RSpec.describe "TransientRegistrations", type: :request do
  let(:transient_registration) { create(:transient_registration, workflow_state: "tier_check_form") }

  describe "/bo/transient-registrations/:reg_identifier" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      it "renders the index template" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}"
        expect(response).to render_template(:show)
      end

      it "returns a 200 response" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}"
        expect(response).to have_http_status(200)
      end

      it "includes a properly-displayed workflow_state" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}"
        expect(response.body).to include("Check your tier")
      end

      context "when a value is not set" do
        before { transient_registration.location = nil }

        it "displays filler text" do
          get "/bo/transient-registrations/#{transient_registration.reg_identifier}"
          expect(response.body).to include("Location: not set")
        end
      end

      it "includes a link to continue the renewal" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}"
        expect(response.body).to include("/bo/renew/#{transient_registration.reg_identifier}")
      end
    end
  end
end
