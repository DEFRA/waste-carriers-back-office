# frozen_string_literal: true

require "rails_helper"

module Notify
  RSpec.describe UnlockInstructionsEmailService do
    describe ".send_email" do
      let(:template_id) { "a3295516-26a6-4c01-9e3a-d5000f1a86c6" }
      let(:user) { create(:user, email: "test@example.com") }
      let(:token) { "example_token" }

      let(:expected_notify_options) do
        {
          email_address: user.email,
          template_id: template_id,
          personalisation: {
            email_address: user.email,
            unlock_link: Rails.application.routes.url_helpers.user_unlock_url(
              host: Rails.configuration.wcrs_back_office_url,
              unlock_token: token
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
    end
  end
end
