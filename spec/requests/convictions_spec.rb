# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Convictions", type: :request do
  let(:transient_registration) { create(:transient_registration, workflow_state: "tier_check_form") }

  describe "/bo/transient-registrations/:reg_identifier/convictions" do
    context "when a valid user is signed in" do
      let(:user) { create(:user) }
      before(:each) do
        sign_in(user)
      end

      it "renders the index template" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions"
        expect(response).to render_template(:index)
      end

      it "returns a 200 response" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions"
        expect(response).to have_http_status(200)
      end

      it "includes the reg identifier" do
        get "/bo/transient-registrations/#{transient_registration.reg_identifier}/convictions"
        expect(response.body).to include(transient_registration.reg_identifier)
      end
    end
  end
end
