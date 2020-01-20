# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ConvictionImports", type: :request do
  describe "GET /bo/import-convictions" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :developer) }
      before(:each) do
        sign_in(user)
      end

      it "renders the new template" do
        get "/bo/import-convictions"
        expect(response).to render_template(:new)
      end

      it "returns a 200 response" do
        get "/bo/import-convictions"
        expect(response).to have_http_status(200)
      end
    end

    context "when a non-developer user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        get "/bo/import-convictions"
        expect(response).to redirect_to("/bo/pages/permission")
      end
    end
  end

  describe "POST /bo/import-convictions" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :developer) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the results page" do
        post "/bo/import-convictions"
        expect(response).to redirect_to("/bo")
      end
    end

    context "when a non-developer user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "redirects to the permissions error page" do
        post "/bo/import-convictions"
        expect(response).to redirect_to("/bo/pages/permission")
      end
    end
  end
end
