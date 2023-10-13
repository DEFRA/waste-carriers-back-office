# frozen_string_literal: true

require "rails_helper"

module Notify
  RSpec.describe ResetPasswordInstructionsEmailService do
    describe ".send_email" do
      let(:template_id) { "bfe66f5e-29ed-4f78-82e1-8baf5548f97a" }
      let(:user) { create(:user, email: "test@example.com") }
      let(:token) { "example_token" }

      let(:expected_notify_options) do
        {
          email_address: user.email,
          template_id: template_id,
          personalisation: {
            email_address: user.email,
            reset_password_link: Rails.application.routes.url_helpers.edit_user_password_url(
              host: Rails.configuration.wcrs_back_office_url,
              reset_password_token: token
            )
          }
        }
      end

      let(:notifications_client) { instance_double(Notifications::Client) }

      before do
        allow(Notifications::Client).to receive(:new).and_return(notifications_client)
        allow(notifications_client).to receive(:send_email)

        described_class.new.send_email(user, { token: token })
      end

      context "with an email" do

        it "sends an email" do
          expect(notifications_client).to have_received(:send_email).with(expected_notify_options)
        end
      end

      context "with no email" do
        before { user.email = nil }

        it "sends an email" do
          expect(notifications_client).not_to have_received(:send_email).with(expected_notify_options)
        end
      end
    end
  end
end
