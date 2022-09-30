# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User Roles", type: :request do
  let(:role_change_user) { create(:user) }

  describe "GET /users/:id/role" do
    context "when a super user is signed in" do
      before do
        sign_in(create(:user, :agency_super))
      end

      it "renders the new template" do
        get "/bo/users/#{role_change_user.id}/role"

        expect(response).to render_template(:new)
      end

      context "when the current user does not have permission to manage this user" do
        let(:role_change_user) { create(:user, :finance) }

        it "redirects to the permissions error page" do
          get "/bo/users/#{role_change_user.id}/role"

          expect(response).to redirect_to("/bo/pages/permission")
        end
      end
    end
  end

  describe "POST /users/:id/role" do
    let(:params) { { role: "agency_with_refund" } }

    context "when a super user is signed in" do
      before do
        sign_in(create(:user, :agency_super))
      end

      it "updates the user role and redirects to the user list" do
        post "/bo/users/#{role_change_user.id}/role", params: { user: params }

        expect(role_change_user.reload.role).to eq(params[:role])
        expect(response).to redirect_to(users_path)
      end

      context "when the params are invalid" do
        let(:params) { { role: "foo" } }

        it "does not update the user role and renders the new template" do
          post "/bo/users/#{role_change_user.id}/role", params: { user: params }

          expect(role_change_user.reload.role).to eq("agency")
          expect(response).to render_template(:new)
        end
      end

      context "when the params are blank" do
        it "does not update the user role and renders the new template" do
          post "/bo/users/#{role_change_user.id}/role"

          expect(role_change_user.reload.role).to eq("agency")
          expect(response).to render_template(:new)
        end
      end

      context "when the current user does not have permission to select this role" do
        let(:params) { { role: "finance_super" } }

        it "does not update the user role and renders the new template" do
          post "/bo/users/#{role_change_user.id}/role", params: { user: params }

          expect(role_change_user.reload.role).to eq("agency")
          expect(response).to render_template(:new)
        end
      end

      context "when the current user does not have permission to manage this user" do
        let(:role_change_user) { create(:user, :finance) }

        it "redirects to the permissions error page" do
          get "/bo/users/#{role_change_user.id}/role", params: { user: params }

          expect(response).to redirect_to("/bo/pages/permission")
        end
      end
    end
  end
end
