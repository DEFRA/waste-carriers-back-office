# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Registrations" do
  let(:registration) { create(:registration) }
  let(:reg_identifier) { registration.reg_identifier }

  describe "/bo/registrations/:reg_identifier" do
    let(:headers) { {} }

    context "when a valid user is signed in" do
      let(:user) { create(:user) }

      before do
        sign_in(user)
        get "/bo/registrations/#{reg_identifier}", headers: headers
      end

      it "renders the show template" do
        expect(response).to render_template(:show)
      end

      it "returns a 200 response" do
        expect(response).to have_http_status(:ok)
      end

      context "when HTTP referer is not set" do
        it "the back link points to the dashboard" do
          expect(response.body).to match(%r{href="/bo">Dashboard})
        end
      end

      context "when HTTP `referer` is set" do
        let(:referrer) { Faker::Internet.url }
        let(:headers) { { "HTTP_REFERER" => referrer } }

        it "the back link points to the dashboard" do
          expect(response.body).to match(%r{href="/bo">Dashboard})
        end
      end

      context "when no matching registration exists" do
        let(:reg_identifier) { "foo" }

        it "redirects to the dashboard" do
          expect(response).to redirect_to(bo_path)
        end
      end
    end
  end
end
