# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RenewingRegistrations", type: :request do
  let(:transient_registration) { create(:renewing_registration, workflow_state: "tier_check_form") }

  describe "/bo/renewing-registrations/:reg_identifier" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      it "renders the index template" do
        get "/bo/renewing-registrations/#{transient_registration.reg_identifier}"
        expect(response).to render_template(:show)
      end

      it "returns a 200 response" do
        get "/bo/renewing-registrations/#{transient_registration.reg_identifier}"
        expect(response).to have_http_status(200)
      end

      it "includes a properly-displayed workflow_state" do
        get "/bo/renewing-registrations/#{transient_registration.reg_identifier}"
        expect(response.body).to include("Check your tier")
      end

      it "includes a link to continue the renewal" do
        get "/bo/renewing-registrations/#{transient_registration.reg_identifier}"
        expect(response.body).to include("/bo/renew/#{transient_registration.reg_identifier}")
      end

      context "when no matching transient_registration exists" do
        context "when a registration exist with that identifier" do
          let(:registration) { create(:registration) }

          it "rerdirects to the registration details page" do
            get "/bo/renewing-registrations/#{registration.reg_identifier}"

            expect(response).to redirect_to(registration_path(registration.reg_identifier))
          end
        end

        it "redirects to the dashboard" do
          get "/bo/renewing-registrations/foo"

          expect(response).to redirect_to(bo_path)
        end
      end
    end
  end
end
