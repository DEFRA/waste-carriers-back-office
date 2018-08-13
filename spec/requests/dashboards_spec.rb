# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Dashboards", type: :request do
  describe "/bo" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      it "renders the index template" do
        get "/bo"
        expect(response).to render_template(:index)
      end

      it "returns a 200 response" do
        get "/bo"
        expect(response).to have_http_status(200)
      end
    end

    context "when a user is not signed in" do
      it "redirects to the sign-in page" do
        get "/bo"
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
