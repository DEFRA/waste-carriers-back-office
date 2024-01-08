# frozen_string_literal: true

require "rails_helper"

RSpec.describe "External Certificates" do
  let(:registration) { create(:registration, :expires_soon, contact_email: "contact@example.com") }
  let(:valid_email) { registration.contact_email }
  let(:invalid_email) { "invalid@example.com" }
  let(:base_path) { "/bo/registrations/#{registration.reg_identifier}/external/certificate" }

  describe "POST process_email" do
    context "with valid email" do
      it "sets the valid email in session and redirects to the certificate page" do
        post process_email_path, params: { email: valid_email }
        expect(response).to redirect_to(base_path)
      end
    end

    context "with invalid email" do
      it "does not set the email in session and renders the confirmation page with an error" do
        post process_email_path, params: { email: invalid_email }

        expect(flash[:error]).to be_present
        expect(response).to render_template(:confirm_email)
      end
    end
  end

  describe "GET show" do
    context "with valid email in session" do
      before do
        post process_email_path, params: { email: valid_email }
      end

      it "renders the HTML certificate" do
        get base_path

        expect(response.media_type).to eq("text/html")
        expect(response).to have_http_status(:ok)
      end
    end

    context "without valid email in session" do
      before do
        post process_email_path, params: { email: invalid_email }
      end

      it "redirects to the email confirmation page" do
        get base_path

        expect(response).to redirect_to(registration_external_certificate_confirm_email_path(registration.reg_identifier))
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe "GET pdf" do
    let(:base_path) { "/bo/registrations/#{registration.reg_identifier}/external/pdf_certificate" }

    context "with valid email in session" do
      before do
        post process_email_path, params: { email: valid_email }
      end

      it "responds with a PDF with a filename that includes the registration reference and returns a 200 status code" do
        get base_path

        expect(response.media_type).to eq("application/pdf")
        expected_content_disposition = "inline; filename=\"#{registration.reg_identifier}.pdf\"; filename*=UTF-8''#{registration.reg_identifier}.pdf"
        expect(response.headers["Content-Disposition"]).to eq(expected_content_disposition)
        expect(response).to have_http_status(:ok)
      end
    end

    context "without valid email in session" do
      before do
        post process_email_path, params: { email: invalid_email }
      end

      it "redirects to the email confirmation page" do
        get "#{base_path}.pdf"

        expect(response).to redirect_to(registration_external_certificate_confirm_email_path(registration.reg_identifier))
        expect(response).to have_http_status(:found)
      end
    end
  end

  describe "GET confirm_email" do
    it "renders the confirm email page" do
      get registration_external_certificate_confirm_email_path(registration.reg_identifier)
      expect(response).to render_template(:confirm_email)
    end
  end

  def process_email_path
    registration_external_certificate_process_email_path(registration.reg_identifier)
  end
end
