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

      it "includes the title of each communication" do
        expect(response.body).to include(email.comms_label)
        expect(response.body).to include(letter.comms_label)
        expect(response.body).to include(text.comms_label)
      end

      it "links each title to the communication detail page" do
        expect(response.body).to include("/bo/registrations/#{registration.reg_identifier}/communication_records/#{email.id}")
        expect(response.body).to include("/bo/registrations/#{registration.reg_identifier}/communication_records/#{letter.id}")
        expect(response.body).to include("/bo/registrations/#{registration.reg_identifier}/communication_records/#{text.id}")
      end

      it "includes the delivery status of each communication" do
        expect(response.body).to include(email.delivery_status)
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

  describe "GET /bo/registrations/:reg_identifier/communication_records/:id" do
    let(:communication_record) { create(:communication_record, :email, registration: registration) }

    context "when the communication record exists" do
      before do
        get "/bo/registrations/#{registration.reg_identifier}/communication_records/#{communication_record.id}"
      end

      it "renders the show template" do
        expect(response).to render_template(:show)
      end

      it "returns a 200 response" do
        expect(response).to have_http_status(:ok)
      end

      it "includes the correct header" do
        expect(response.body).to include("Communication history")
      end

      it "includes the communication details" do
        expect(response.body).to include(communication_record.comms_label)
        expect(response.body).to include(communication_record.notify_template_id)
        expect(response.body).to include(communication_record.notification_type)
        expect(response.body).to include(communication_record.sent_to)
        expect(response.body).to include(communication_record.delivery_status)
      end

      it "includes the communication content" do
        expect(response.body).to include(">Content</dt>")
        expect(response.body).to include("Please pay for your waste carrier registration.")
      end
    end

    context "when the communication record has no persisted content" do
      let(:communication_record) do
        create(:communication_record, :email, registration: registration, content: nil, delivery_status: nil)
      end

      before do
        get "/bo/registrations/#{registration.reg_identifier}/communication_records/#{communication_record.id}"
      end

      it "returns a 200 response" do
        expect(response).to have_http_status(:ok)
      end

      it "does not include the content row" do
        expect(response.body).not_to include(">Content</dt>")
      end
    end

    context "when user has no access" do
      let(:user) { create(:user, role: :finance) }

      it "redirects to the permissions page" do
        get "/bo/registrations/#{registration.reg_identifier}/communication_records/#{communication_record.id}"

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end

    context "when the communication record does not exist" do
      it "redirects to the system error page" do
        get "/bo/registrations/#{registration.reg_identifier}/communication_records/aaaaaaaaaaaaaaaaaaaaaaaa"

        expect(response).to redirect_to("/bo/pages/system_error")
      end
    end
  end
end
