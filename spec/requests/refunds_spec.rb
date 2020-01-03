# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Refunds", type: :request do
  describe "GET /bo/finance_details/:_id/refunds" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      let(:renewing_registration) { create(:renewing_registration, :has_finance_details) }

      before(:each) do
        sign_in(user)
      end

      it "renders the index template and returns a 200 status" do
        get finance_details_refunds_path(renewing_registration._id)

        expect(response).to render_template(:index)
        expect(response).to have_http_status(200)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get finance_details_refunds_path("foo")

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "GET /bo/finance_details/:_id/refunds/new" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      let(:renewing_registration) { create(:renewing_registration, :has_finance_details) }

      before(:each) do
        sign_in(user)
      end

      it "renders the index template and returns a 200 status" do
        get new_finance_details_refunds_path(renewing_registration._id)

        expect(response).to render_template(:index)
        expect(response).to have_http_status(200)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get new_finance_details_refunds_path("foo")

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  # TODO
  skip "POST /bo/finance_details/:_id/refunds/:order_key"
end
