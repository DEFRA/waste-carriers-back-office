# frozen_string_literal: true

require "rails_helper"

module Notify
  RSpec.describe RenewalReminderEmailService do
    let(:template_id) { "51cfcf60-7506-4ee7-9400-92aa90cf983c" }
    let(:registration) { create(:registration, :expires_soon) }
    let(:reg_identifier) { registration.reg_identifier }

    describe ".run" do
      let(:expected_notify_options) do
        {
          email_address: registration.contact_email,
          template_id: "51cfcf60-7506-4ee7-9400-92aa90cf983c",
          personalisation: {
            reg_identifier: reg_identifier,
            first_name: "Jane",
            last_name: "Doe",
            expires_on: registration.expires_on.to_formatted_s(:day_month_year),
            renew_fee: "105",
            renew_link: "http://localhost:3002/fo/renew/#{registration.renew_token}"
          }
        }
      end

      subject do
        VCR.use_cassette("notify_renewal_reminder_sends_an_email") do
          described_class.run(registration: registration)
        end
      end

      context "in general" do
        before do
          expect_any_instance_of(Notifications::Client)
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
      end

      context "when the registration's contact email is missing" do
        before { registration.contact_email = nil }

        it "throws an error" do
          expect { subject }.to raise_error(Exceptions::MissingContactEmailError)
        end
      end

      context "when the registration's contact email matches the assisted digital email" do
        before do
          allow(WasteCarriersEngine.configuration)
            .to receive(:assisted_digital_email)
            .and_return("nccc@example.com")

          registration.contact_email = "nccc@example.com"
        end

        it "throws an error" do
          expect { subject }.to raise_error(Exceptions::AssistedDigitalContactEmailError)
        end
      end
    end
  end
end
