# frozen_string_literal: true

require "rails_helper"

module Notify
  RSpec.describe InvitationInstructionsEmailService do
    describe "#send_email" do
      let(:user) { create(:user, email: "test@example.com", invitation_sent_at: 1.day.ago) }
      let(:token) { "example_token" }

      let(:expected_notify_options) do
        {
          email_address: user.email,
          template_id: "5b5c1a42-b19b-4dc1-bece-4842f42edb65",
          personalisation: {
            invite_link: Rails.application.routes.url_helpers.accept_user_invitation_url(
              host: Rails.configuration.wcrs_back_office_url,
              invitation_token: token
            ),
            service_link: Rails.application.routes.url_helpers.root_url(host: Rails.configuration.wcrs_back_office_url),
            expiry_date: (user.invitation_sent_at + Devise.invite_for).to_s(:day_month_year)
          }
        }
      end

      let(:notifications_client) { instance_double(Notifications::Client) }

      before do
        allow(Notifications::Client).to receive(:new).and_return(notifications_client)
        allow(notifications_client).to receive(:send_email)
        described_class.new.send_email(user, { token: token })
      end

      it "sends an email with correct options" do
        expect(notifications_client).to have_received(:send_email).with(expected_notify_options)
      end
    end
  end
end
