# frozen_string_literal: true

require "rails_helper"

RSpec.describe "TransientRegistrations", type: :request do
  let(:transient_registration) { build(:transient_registration) }

  describe "/bo/transient-registrations/:reg_identifier" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      it "renders the index template" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}"
        expect(response).to render_template(:show)
      end

      it "returns a 200 response" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}"
        expect(response).to have_http_status(200)
      end
    end
  end
end
