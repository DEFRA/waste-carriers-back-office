# frozen_string_literal: true

require "rails_helper"

RSpec.describe "EmailExportsLists" do
  describe "GET /bo/email-exports-lists" do

    context "when a CBD user is signed in" do
      let(:user) { create(:user, role: :cbd_user) }

      before { sign_in(user) }

      it "renders the new template" do
        get "/bo/email-exports-list/new"

        expect(response).to render_template(:new)
      end

      it "returns a 200 response" do
        get "/bo/email-exports-list/new"

        expect(response).to have_http_status(:ok)
      end
    end

    context "when a non-CBD user is signed in" do
      let(:user) { create(:user, role: :agency) }

      before do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/email-exports-list/new"

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end

    context "when no user is signed in" do
      it "redirects the user to the sign in page" do
        get "/bo/email-exports-list/new"

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
