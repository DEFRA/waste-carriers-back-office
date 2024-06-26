# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RenewingRegistrations" do
  let(:transient_registration) { create(:renewing_registration, workflow_state: "tier_check_form") }

  describe "/bo/renewing-registrations/:reg_identifier" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      it "renders the index template and returns a 200 response" do
        get "/bo/renewing-registrations/#{transient_registration.reg_identifier}"

        expect(response).to render_template(:show)
        expect(response).to have_http_status(:ok)
      end

      it "includes a properly-displayed workflow_state and includes a link to continue the renewal" do
        get "/bo/renewing-registrations/#{transient_registration.reg_identifier}"

        expect(response.body).to include("Renewal details")
        expect(response.body).to include("/bo/ad-privacy-policy?reg_identifier=#{transient_registration.reg_identifier}")
      end

      context "when no matching transient_registration exists" do
        context "when a registrations exist with that reg_identifier" do
          let(:registration) { create(:registration) }

          it "redirects to the registration details page" do
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
