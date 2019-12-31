# frozen_string_literal: true

require "rails_helper"

RSpec.describe "FinanceDetails", type: :request do
  describe "GET /bo/registrations/:reg_identifier/finance_details" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      let(:registration) { create(:registration, :has_orders_and_payments) }

      before(:each) do
        sign_in(user)
      end

      it "renders the show template and returns a 200 status" do
        get registration_finance_details_path(registration.reg_identifier)

        expect(response).to render_template(:show)
        expect(response).to have_http_status(200)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get registration_finance_details_path("doo")
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
