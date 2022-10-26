# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Pages" do
  describe "/bo/pages/deactivated" do
    context "when an active user is logged in" do
      before do
        sign_in(create(:user))
      end

      it "displays the correct page" do
        get "/bo/pages/deactivated"

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:deactivated)
      end
    end

    context "when an inactive user is logged in" do
      before do
        sign_in(create(:user, :inactive))
      end

      it "displays the correct page" do
        get "/bo/pages/deactivated"

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:deactivated)
      end
    end

    context "when no user is logged in" do
      it "displays the correct page" do
        get "/bo/pages/deactivated"

        expect(response).to have_http_status(:ok)
        expect(response).to render_template(:deactivated)
      end
    end
  end
end
