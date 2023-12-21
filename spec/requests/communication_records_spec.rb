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
      it "renders the index template, returns a 200 response and includes the correct content" do
        email = create(:communication_record, :email, registration: registration)
        letter = create(:communication_record, :letter, registration: registration)
        text = create(:communication_record, :text, registration: registration)

        get "/bo/registrations/#{registration.reg_identifier}/communication_records"

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Communication history")
        expect(response.body).to include(email.sent_to)
        expect(response.body).to include(letter.sent_to)
        expect(response.body).to include(text.sent_to)
      end
    end

    context "when communication history is empty" do
      it "renders the index template, returns a 200 response and includes the correct content" do
        get "/bo/registrations/#{registration.reg_identifier}/communication_records"

        expect(response).to render_template(:index)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("Communication history")
        expect(response.body).to include("No results found")
      end
    end

    context "when user has no access or registration does not exist" do
      it "redirects to the system error page" do
        get "/bo/registrations/NOT-EXISTING/communication_records"

        expect(response).to redirect_to("/bo/pages/system_error")
      end
    end
  end
end
