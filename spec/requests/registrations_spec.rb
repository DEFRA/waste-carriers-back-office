# frozen_string_literal: true

require "rails_helper"

RSpec.describe "RenewingRegistrations", type: :request do
  let(:registration) { create(:registration) }

  describe "/bo/registrations/:reg_identifier" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      it "renders the index template" do
        get "/bo/registrations/#{registration.reg_identifier}"
        expect(response).to render_template(:show)
      end

      it "returns a 200 response" do
        get "/bo/registrations/#{registration.reg_identifier}"
        expect(response).to have_http_status(200)
      end

      it "includes a properly-displayed workflow_state" do
        get "/bo/registrations/#{registration.reg_identifier}"
        expect(response.body).to include("Check your tier")
      end

      it "includes a link to continue the renewal" do
        get "/bo/registrations/#{registration.reg_identifier}"
        expect(response.body).to include("/bo/renew/#{registration.reg_identifier}")
      end

      context "when no matching registration exists" do
        it "redirects to the dashboard" do
          get "/bo/registrations/foo"
          expect(response).to redirect_to(bo_path)
        end
      end
    end
  end
end
