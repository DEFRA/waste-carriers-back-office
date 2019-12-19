# frozen_string_literal: true

require "rails_helper"

RSpec.describe "User Activations", type: :request do
  let(:current_user_role) { :agency_super }
  let(:subject_user_role) { :agency }
  let(:active_user) { create(:user, role: subject_user_role) }
  let(:inactive_user) { create(:user, :inactive, role: subject_user_role) }

  describe "GET /bo/users/activate/:id" do
    context "when a super user is signed in" do
      let(:user) { create(:user, role: current_user_role) }
      before(:each) do
        sign_in(user)
      end

      context "when the current user has permission to activate the user" do
        context "when the user to be activated is inactive" do
          it "renders the activate_form template" do
            get "/bo/users/activate/#{inactive_user.id}"
            expect(response).to render_template(:activate_form)
          end
        end

        context "when the user to be activated is already active" do
          it "redirects to the user list" do
            get "/bo/users/activate/#{active_user.id}"
            expect(response).to redirect_to(users_path)
          end
        end
      end

      context "when the current user does not have permission to activate the user" do
        let(:current_user_role) { :finance_super }

        it "redirects to a permission error" do
          get "/bo/users/activate/#{inactive_user.id}"
          expect(response).to redirect_to("/bo/pages/permission")
        end
      end
    end
  end

  describe "GET /bo/users/deactivate/:id" do
    context "when a super user is signed in" do
      let(:user) { create(:user, role: current_user_role) }
      before(:each) do
        sign_in(user)
      end

      context "when the current user has permission to activate the user" do
        let(:current_user_role) { :finance_super }
        let(:subject_user_role) { :finance }

        context "when the user to be deactivated is active" do
          it "renders the deactivate_form template" do
            get "/bo/users/deactivate/#{active_user.id}"
            expect(response).to render_template(:deactivate_form)
          end
        end

        context "when the user to be deactivated is already inactive" do
          it "redirects to the user list" do
            get "/bo/users/deactivate/#{inactive_user.id}"
            expect(response).to redirect_to(users_path)
          end
        end
      end

      context "when the current user does not have permission to activate the user" do
        let(:subject_user_role) { :finance }

        it "redirects to a permission error" do
          get "/bo/users/deactivate/#{active_user.id}"
          expect(response).to redirect_to("/bo/pages/permission")
        end
      end
    end
  end

  describe "POST /bo/users/activate" do
    context "when a super user is signed in" do
      let(:user) { create(:user, role: current_user_role) }
      before(:each) do
        sign_in(user)
      end

      context "when the current user has permission to activate the user" do
        context "when the user to be activated is inactive" do
          it "redirects to the user list" do
            post "/bo/users/activate/#{inactive_user.id}"
            expect(response).to redirect_to(users_path)
          end

          it "activates the user" do
            post "/bo/users/activate/#{inactive_user.id}"
            expect(inactive_user.reload.active?).to eq(true)
          end
        end

        context "when the user to be activated is already active" do
          it "redirects to the user list" do
            post "/bo/users/activate/#{active_user.id}"
            expect(response).to redirect_to(users_path)
          end
        end
      end

      context "when the current user does not have permission to activate the user" do
        let(:subject_user_role) { :finance }

        it "redirects to a permission error" do
          post "/bo/users/activate/#{inactive_user.id}"
          expect(response).to redirect_to("/bo/pages/permission")
        end
      end
    end
  end

  describe "POST /bo/users/deactivate" do
    context "when a super user is signed in" do
      let(:user) { create(:user, role: current_user_role) }
      before(:each) do
        sign_in(user)
      end

      context "when the current user has permission to activate the user" do
        let(:current_user_role) { :finance_super }
        let(:subject_user_role) { :finance }

        context "when the user to be deactivated is active" do
          it "redirects to the user list" do
            post "/bo/users/deactivate/#{active_user.id}"
            expect(response).to redirect_to(users_path)
          end

          it "deactivates the user" do
            post "/bo/users/deactivate/#{active_user.id}"
            expect(active_user.reload.active?).to eq(false)
          end
        end

        context "when the user to be deactivated is already inactive" do
          it "redirects to the user list" do
            post "/bo/users/deactivate/#{inactive_user.id}"
            expect(response).to redirect_to(users_path)
          end
        end
      end

      context "when the current user does not have permission to activate the user" do
        let(:current_user_role) { :finance_super }

        it "redirects to a permission error" do
          post "/bo/users/deactivate/#{active_user.id}"
          expect(response).to redirect_to("/bo/pages/permission")
        end
      end
    end
  end
end
