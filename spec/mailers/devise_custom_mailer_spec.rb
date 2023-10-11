# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeviseCustomMailer do
  describe "#invitation_instructions" do
    let(:user) { create(:user, email: "test@example.com", invitation_created_at: Time.zone.now) }
    let(:token) { "example_token" }
    let(:opts) { {} }

    let(:expected_notify_options) do
      {
        template: :invitation_instructions,
        record: user,
        opts: {
          invite_link: invite_url,
          invitation_due_at: user.invitation_due_at,
          service_link: service_url
        }
      }
    end

    let(:invite_url) do
      Rails.application.routes.url_helpers.accept_user_invitation_url(
        host: Rails.configuration.wcrs_back_office_url,
        invitation_token: token
      )
    end

    let(:service_url) do
      Rails.application.routes.url_helpers.root_url(host: Rails.configuration.wcrs_back_office_url)
    end

    before do
      allow(WasteCarriersEngine::Notify::DeviseSender).to receive(:run)
    end

    it "calls the Notify::DeviseSender with expected arguments" do
      described_class.new.invitation_instructions(user, token, opts)

      expect(WasteCarriersEngine::Notify::DeviseSender).to have_received(:run).with(expected_notify_options)
    end
  end
end
