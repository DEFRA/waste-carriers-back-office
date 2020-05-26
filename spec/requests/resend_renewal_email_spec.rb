# frozen_string_literal: true

require "rails_helper"

RSpec.describe "ResendRenewalEmail", type: :request do
  describe "GET /bo/resend-renewal-email/:reg_identifier" do
    let(:registration) { create(:registration, :expires_soon) }
    let(:request_path) { "/bo/resend-renewal-email/#{registration.reg_identifier}" }

    context "when a finance user is signed in" do
      let(:user) { create(:user, :finance) }
      before { sign_in(user) }

      it "redirects to permission page" do
        get request_path, {}, "HTTP_REFERER" => "/"

        expect(response).to redirect_to("/bo/pages/permission")
      end
    end

    context "when an agency user is signed in" do
      let(:user) { create(:user, :agency) }
      before { sign_in(user) }

      it "sends an email and redirects to the previous page" do
        expected_count = ActionMailer::Base.deliveries.count + 1

        get request_path, {}, "HTTP_REFERER" => "/"

        expect(ActionMailer::Base.deliveries.count).to eq(expected_count)
        expect(response).to redirect_to("/")
      end

      context "when an error happens", disable_bullet: true do
        before do
          expect(RenewalReminderMailer).to receive(:second_reminder_email).and_raise(StandardError)
        end

        it "does not sends an email and redirects to the previous page" do
          expected_count = ActionMailer::Base.deliveries.count

          get request_path, {}, "HTTP_REFERER" => "/"

          expect(ActionMailer::Base.deliveries.count).to eq(expected_count)
          expect(response).to redirect_to("/")
        end
      end
    end
  end
end
