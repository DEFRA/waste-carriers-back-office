# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Users", type: :request do
  describe "/bo/users" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      it "renders the index template" do
        get "/bo/users"
        expect(response).to render_template(:index)
      end

      it "returns a 200 response" do
        get "/bo/users"
        expect(response).to have_http_status(200)
      end

      it "includes the correct content" do
        get "/bo/users"
        expect(response.body).to include("Manage back office users")
      end
    end
  end
end
