# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Communication Records" do
  let(:registration) { create(:registration) }
  let(:user) { create(:user, role: :agency_with_refund) }

  before do
    sign_in(user)
  end

  describe "GET /bo/registrations/:reg_identifier/communication_records/" do
    context "when communication history is present" do
      let(:email) { create(:communication_record, :email, registration: registration) }
      let(:letter) { create(:communication_record, :letter, registration: registration) }
      let(:text) { create(:communication_record, :text, registration: registration) }

      before do
        email
        letter
        text
        get "/bo/registrations/#{registration.reg_identifier}/communication_records"
      end

      it "renders the index template" do
        expect(response).to render_template(:index)
      end

      it "returns a 200 response" do
        expect(response).to have_http_status(:ok)
      end

      it "includes the correct header" do
        expect(response.body).to include("Communication history")
      end

      it "includes the correct recipient for email type communication" do
        expect(response.body).to include(email.sent_to)
      end

      it "includes the correct recipient for letter type communication" do
        expect(response.body).to include(letter.sent_to)
      end

      it "includes the correct recipient for text type communication" do
        expect(response.body).to include(text.sent_to)
      end
    end

    context "when communication history is empty" do
      before do
        get "/bo/registrations/#{registration.reg_identifier}/communication_records"
      end

      it "renders the index template" do
        expect(response).to render_template(:index)
      end

      it "returns a 200 response" do
        expect(response).to have_http_status(:ok)
      end

      it "includes the correct header" do
        expect(response.body).to include("Communication history")
      end

      it "includes the correct content" do
        expect(response.body).to include("No results found")
      end
    end

    context "when user has no access" do
      let(:user) { create(:user, role: :finance) }

      it "redirects to the permissions page" do
        get "/bo/registrations/#{registration.reg_identifier}/communication_records"

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end

    context "when registration does not exist" do
      it "redirects to the system error page" do
        get "/bo/registrations/NOT-EXISTING/communication_records"

        expect(response).to redirect_to("/bo/pages/system_error")
      end
    end
  end
end
