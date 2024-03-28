# frozen_string_literal: true

require "rails_helper"

module Notify
  RSpec.describe RenewalReminderEmailService do
    let(:template_id) { "51cfcf60-7506-4ee7-9400-92aa90cf983c" }
    let(:registration) { create(:registration, :expires_soon) }
    let(:reg_identifier) { registration.reg_identifier }

    describe ".run" do
      subject(:run_service) do
        VCR.use_cassette("notify_renewal_reminder_sends_an_email") do
          described_class.run(registration: registration)
        end
      end

      let(:expected_notify_options) do
        {
          email_address: registration.contact_email,
          template_id: "6d20d279-ba79-4fe0-9868-fb09c4ae7733",
          personalisation: {
            reg_identifier: reg_identifier,
            first_name: "Jane",
            last_name: "Doe",
            expires_on: registration.expires_on.to_fs(:day_month_year),
            renew_fee: (Rails.configuration.renewal_charge / 100).to_s,
            renew_link: "#{Rails.configuration.wcrs_fo_link_domain}/fo/renew/#{registration.renew_token}",
            unsubscribe_link: WasteCarriersEngine::UnsubscribeLinkService.run(registration:)
          }
        }
      end
      let(:notifications_client) { Notifications::Client.new(WasteCarriersEngine.configuration.notify_api_key) }

      before { allow(Notifications::Client).to receive(:new).and_return(notifications_client) }

      context "when the contact email is present" do
        before do
          allow(notifications_client)
            .to receive(:send_email)
            .with(expected_notify_options)
            .and_call_original
        end

        it "sends an email" do
          expect(subject).to be_a(Notifications::Client::ResponseNotification)
          expect(subject.template["id"]).to eq(template_id)
          expect(subject.content["subject"]).to match(
            /Renew waste carrier registration CBDU/
          )
        end

        it_behaves_like "can create a communication record", "email"
      end

      context "when the registration's contact email is missing" do
        before { registration.contact_email = nil }

        it "does not throw an error" do
          expect { subject }.not_to raise_error
        end

        it "does not send an email" do
          expect(notifications_client).not_to receive(:send_email)
          subject
        end
      end
    end
  end
end
