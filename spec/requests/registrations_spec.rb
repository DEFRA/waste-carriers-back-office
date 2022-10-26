# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registrations" do
  let(:registration) { create(:registration) }

  describe "/bo/registrations/:reg_identifier" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
      end

      it "renders the index template and returns a 200 response" do
        get "/bo/registrations/#{registration.reg_identifier}"

        expect(response).to render_template(:show)
        expect(response).to have_http_status(:ok)
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
