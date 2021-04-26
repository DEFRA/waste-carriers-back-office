# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewalReminderMailer, type: :mailer do
  # note that the 'first_reminder_email' is now delivered by the
  # RenewalReminderEmailService
  describe ".second_reminder_email" do
    let(:registration) { create(:registration, :expires_soon, contact_email: contact_email) }

    before do
      allow(Rails.configuration).to receive(:email_service_email).and_return("test@example.com")
    end

    context "when the registration's contact email is missing" do
      let(:contact_email) { nil }

      it "throws an error" do
        instance = RenewalReminderMailer.new

        expect { instance.second_reminder_email(registration) }.to raise_error(Exceptions::MissingContactEmailError)
      end
    end

    context "when the registration's contact email is present" do
      context "and it is valid" do
        let(:contact_email) { "foo@example.com" }

        it "sends the second reminder email" do
          mail = described_class.second_reminder_email(registration)

          expect(registration).to receive(:renew_token)
          expect(mail.subject).to include("Renew waste carrier registration")
          expect(mail.to).to eq([registration.contact_email])
          expect(mail.body.encoded).to include(registration.reg_identifier)
        end
      end

      context "but it matches the assisted digital email" do
        before do
          allow(WasteCarriersEngine.configuration).to receive(:assisted_digital_email).and_return(contact_email)
        end

        let(:contact_email) { "nccc@example.com" }

        it "throws an error" do
          instance = RenewalReminderMailer.new

          expect { instance.second_reminder_email(registration) }.to raise_error(Exceptions::AssistedDigitalContactEmailError)
        end
      end
    end
  end
end
