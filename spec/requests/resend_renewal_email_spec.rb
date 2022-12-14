# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ResendRenewalEmail" do
  describe "GET /bo/resend-renewal-email/:reg_identifier" do
    before { sign_in(user) }

    let(:request_path) { "/bo/resend-renewal-email/#{registration.reg_identifier}" }

    context "when a finance user is signed in" do
      let(:user) { create(:user, role: :finance) }
      let(:registration) { create(:registration, :expires_soon) }

      it "redirects to permission page" do
        get request_path, headers: { "HTTP_REFERER" => "/" }

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end

    context "when an agency user is signed in" do
      let(:user) { create(:user, role: :agency) }
      let(:registration) { create(:registration, :expires_soon, contact_email: email) }

      context "when the registration has a contact email" do
        let(:email) { "simone@example.com" }

        it "sends an email, redirects to the previous page and displays a flash 'success' message" do
          VCR.use_cassette("notify_resend_renew_email_when_registration_has_contact_email") do
            get request_path, headers: { "HTTP_REFERER" => "/" }
          end

          expect(response).to redirect_to("/")
          expect(request.flash[:success]).to eq("Renewal email sent to #{email}")
        end
      end

      context "when the registration has no contact email" do
        let(:email) { nil }

        it "does not send an email, redirects to the previous page and displays a flash 'error' message" do
          get request_path, headers: { "HTTP_REFERER" => "/" }

          expect(response).to redirect_to("/")
          expect(request.flash[:error]).to eq("Sorry, there has been a problem re-sending the renewal email.")
        end
      end

      context "when an error happens", disable_bullet: true do
        before do
          allow(Notify::RenewalReminderEmailService).to receive(:run).and_raise(StandardError)
        end

        let(:email) { "oops@example.com" }

        it "does not send an email, redirects to the previous page and displays a flash 'error' message" do
          get request_path, headers: { "HTTP_REFERER" => "/" }

          expect(response).to redirect_to("/")
          expect(request.flash[:error]).to eq("We could not send an email to #{email}")
        end
      end
    end
  end
end
