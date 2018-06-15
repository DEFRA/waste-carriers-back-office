# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboards", type: :request do
  describe "root" do
    context "when a user is signed in" do
      before(:each) do
        user = create(:user)
        sign_in(user)
      end

      it "renders the index template" do
        get "/"
        expect(response).to render_template(:index)
      end

      it "returns a 200 response" do
        get "/"
        expect(response).to have_http_status(200)
      end
    end

    context "when a user is not signed in" do
      before(:each) do
        user = create(:user)
        sign_out(user)
      end

      it "returns a 302 response" do
        get "/"
        expect(response).to have_http_status(302)
      end

      it "redirects to the sign in page" do
        get "/"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
