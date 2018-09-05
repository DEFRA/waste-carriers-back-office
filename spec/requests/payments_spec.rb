# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Payments", type: :request do
  let(:transient_registration) { create(:transient_registration) }

  describe "GET /bo/transient-registrations/:reg_identifier/payments" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      it "renders the new template" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments"
        expect(response).to render_template(:new)
      end

      it "returns a 200 response" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/payments"
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "POST /bo/transient-registrations/:reg_identifier/payments" do
    context "when a valid user is signed in" do
      let(:user) { create(:user, :agency) }
      before(:each) do
        sign_in(user)
      end

      let(:params) do
        {
          reg_identifier: transient_registration.reg_identifier,
          payment_type: "foo"
        }
      end
    end
  end
end
