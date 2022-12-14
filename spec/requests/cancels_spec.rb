# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Cancels" do
  describe "GET /bo/resource/:_id/cancel" do
    context "when an agency with refund user is signed in" do
      let(:user) { create(:user, role: :agency_with_refund) }
      let(:registration) { create(:registration) }

      before do
        sign_in(user)
      end

      it "renders the new template and returns a 200 status" do
        get new_resource_cancel_path(registration._id)

        expect(response).to render_template(:new)
        expect(response).to have_http_status(:ok)
      end
    end

    context "when a finance super user is signed in" do
      let(:user) { create(:user, role: :finance_super) }
      let(:registration) { create(:registration) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions page" do
        get new_resource_cancel_path(registration._id)

        expect(response).to redirect_to("/bo/pages/permission")
        expect(response).to have_http_status(:found)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get new_resource_cancel_path("foo")

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /bo/resource/:_id/charge-adjust" do
    context "when an agency with refund user is signed in" do
      let(:user) { create(:user, role: :agency_with_refund) }
      let(:registration) { create(:registration, :pending) }

      before do
        sign_in(user)
      end

      it "changes the status of the registration to inactive and redirects to the details page with a 302 status" do
        post resource_cancels_path(registration._id)

        registration.reload

        expect(registration).to be_inactive
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(registration_path(registration.reg_identifier))
      end
    end
  end
end
