# frozen_string_literal: true

require "rails_helper"

RSpec.describe "NewRegistrations" do
  let(:transient_registration) { create(:new_registration, workflow_state: "check_your_tier_form") }

  describe "/bo/new-registrations/:token" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      it "renders the index template and returns a 200 response" do
        get "/bo/new-registrations/#{transient_registration.token}"

        expect(response).to render_template(:show)
        expect(response).to have_http_status(:ok)
      end

      context "when no matching transient_registration exists" do
        it "redirects to the dashboard" do
          get "/bo/new-registrations/foo"

          expect(response).to redirect_to(bo_path)
        end
      end
    end
  end
end
