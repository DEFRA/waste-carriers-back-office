# frozen_string_literal: true

require "rails_helper"

RSpec.describe "FinanceDetails", type: :request do
  describe "GET /bo/finance_details/:_id" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }

      before(:each) do
        sign_in(user)
      end

      context "when the registration is a transient object" do
        let(:renewing_registration) { create(:renewing_registration, :has_finance_details) }

        it "renders the show template and returns a 200 status" do
          get finance_details_path(renewing_registration._id)

          expect(response).to render_template(:show)
          expect(response).to have_http_status(200)
        end
      end

      context "when the registration is not a transient object" do
        let(:registration) { create(:registration, :has_orders_and_payments) }

        it "renders the show template and returns a 200 status" do
          get finance_details_path(registration._id)

          expect(response).to render_template(:show)
          expect(response).to have_http_status(200)
        end
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get finance_details_path("doo")

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
