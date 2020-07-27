# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ResendRenewalEmail", type: :request do
  describe "GET /bo/resend-renewal-email/:reg_identifier" do
    before(:each) { sign_in(user) }

    let(:request_path) { "/bo/resend-renewal-email/#{registration.reg_identifier}" }

    context "when a finance user is signed in" do
      let(:user) { create(:user, :finance) }
      let(:registration) { create(:registration, :expires_soon) }

      it "redirects to permission page" do
        get request_path, headers: { "HTTP_REFERER" => "/" }

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end

    context "when an agency user is signed in" do
      let(:user) { create(:user, :agency) }
      let(:registration) { create(:registration, :expires_soon, contact_email: email) }

      context "and the registration has a contact email" do
        let(:email) { "simone@example.com" }

        it "sends an email, redirects to the previous page and displays a flash 'success' message" do
          expected_count = ActionMailer::Base.deliveries.count + 1

          get request_path, headers: { "HTTP_REFERER" => "/" }

          expect(ActionMailer::Base.deliveries.count).to eq(expected_count)
          expect(response).to redirect_to("/")
          expect(request.flash[:success]).to eq("Renewal email sent to #{email}")
        end

        context "but it matches the assisted digital email" do
          before do
            allow(WasteCarriersEngine.configuration).to receive(:assisted_digital_email).and_return(email)
          end

          let(:email) { "nccc@example.com" }

          it "does not send an email, redirects to the previous page and displays a flash 'error' message" do
            expected_count = ActionMailer::Base.deliveries.count

            get request_path, headers: { "HTTP_REFERER" => "/" }

            expect(ActionMailer::Base.deliveries.count).to eq(expected_count)
            expect(response).to redirect_to("/")
            expect(request.flash[:error]).to eq("Sorry, there has been a problem re-sending the renewal email.")
          end
        end
      end

      context "and the registration has no contact email" do
        let(:email) { nil }

        it "does not send an email, redirects to the previous page and displays a flash 'error' message" do
          expected_count = ActionMailer::Base.deliveries.count

          get request_path, headers: { "HTTP_REFERER" => "/" }

          expect(ActionMailer::Base.deliveries.count).to eq(expected_count)
          expect(response).to redirect_to("/")
          expect(request.flash[:error]).to eq("Sorry, there has been a problem re-sending the renewal email.")
        end
      end

      context "when an error happens", disable_bullet: true do
        before do
          allow(RenewalReminderMailer).to receive(:second_reminder_email).and_raise(StandardError)
        end

        let(:email) { "oops@example.com" }

        it "does not send an email, redirects to the previous page and displays a flash 'error' message" do
          expected_count = ActionMailer::Base.deliveries.count

          get request_path, headers: { "HTTP_REFERER" => "/" }

          expect(ActionMailer::Base.deliveries.count).to eq(expected_count)
          expect(response).to redirect_to("/")
          expect(request.flash[:error]).to eq("We could not send an email to #{email}")
        end
      end
    end
  end
end
