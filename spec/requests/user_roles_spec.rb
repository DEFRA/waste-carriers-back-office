# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User Roles", type: :request do
  let(:role_change_user) { create(:user) }

  describe "GET /users/:id/role" do
    context "when a super user is signed in" do
      before(:each) do
        sign_in(create(:user, :agency_super))
      end

      it "renders the edit template" do
        get "/users/#{role_change_user.id}/role"
        expect(response).to render_template(:edit)
      end
    end
  end

  describe "POST /users/:id/role" do
    context "when a super user is signed in" do
      before(:each) do
        sign_in(create(:user, :agency_super))
      end

      it "redirects to the user list" do
        post "/users/#{role_change_user.id}/role"
        expect(response).to redirect_to(users_path)
      end
    end
  end
end
