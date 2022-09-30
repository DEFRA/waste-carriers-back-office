# frozen_string_literal: true

require "rails_helper"

module Notify
  RSpec.describe RegistrationTransferWithInviteEmailService do
    let(:template_id) { "98944726-747e-4b40-9d9b-388ada4f57e4" }
    let(:registration) { create(:registration) }
    let(:reg_identifier) { registration.reg_identifier }

    describe ".run" do
      let(:expected_notify_options) do
        {
          email_address: registration.account_email,
          template_id: template_id,
          personalisation: {
            reg_identifier: reg_identifier,
            account_email: registration.account_email,
            company_name: registration.company_name,
            accept_invite_url: "http://localhost:3002/fo/users/invitation/accept?invitation_token=abc-123"
          }
        }
      end

      subject do
        VCR.use_cassette("notify_registration_transfer_with_invite_sends_an_email") do
          described_class.run(registration: registration, token: "abc-123")
        end
      end

      before do
        allow_any_instance_of(Notifications::Client)
          .to receive(:send_email)
          .with(expected_notify_options)
          .and_call_original
      end

      it "sends an email" do
        expect(subject).to be_a(Notifications::Client::ResponseNotification)
        expect(subject.template["id"]).to eq(template_id)
        expect(subject.content["subject"]).to match(
          /The waste carriers registration CBDU.* has been transferred to you/
        )
      end
    end
  end
end
