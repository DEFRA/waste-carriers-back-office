# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewalReminderMailer, type: :mailer do
  describe ".first_reminder_email" do
    before do
      allow(Rails.configuration).to receive(:email_service_email).and_return("test@example.com")
    end

    context "when the registration's contact email is missing" do
      let(:registration) { create(:registration, expires_on: 3.days.from_now, contact_email: nil) }

      it "throws an error" do
        instance = RenewalReminderMailer.new

        expect { instance.first_reminder_email(registration) }.to raise_error(Exceptions::MissingContactEmailError)
      end
    end

    context "when the registration's contact email is present" do
      let(:registration) { create(:registration, expires_on: 3.days.from_now) }

      it "sends a first reminder email" do
        mail = described_class.first_reminder_email(registration)

        expect(registration).to receive(:renew_token)
        expect(mail.subject).to include("Renew waste carrier registration")
        expect(mail.to).to eq([registration.contact_email])
        expect(mail.body.encoded).to include(registration.reg_identifier)
      end
    end
  end

  describe ".second_reminder_email" do
    let(:registration) { create(:registration, expires_on: 3.days.from_now) }

    before do
      allow(Rails.configuration).to receive(:email_service_email).and_return("test@example.com")
    end

    context "when the registration's contact email is missing" do
      let(:registration) { create(:registration, expires_on: 3.days.from_now, contact_email: nil) }

      it "throws an error" do
        instance = RenewalReminderMailer.new

        expect { instance.second_reminder_email(registration) }.to raise_error(Exceptions::MissingContactEmailError)
      end
    end

    context "when the registration's contact email is present" do
      let(:registration) { create(:registration, expires_on: 3.days.from_now) }

      it "sends a second reminder email" do
        mail = described_class.second_reminder_email(registration)

        expect(registration).to receive(:renew_token)
        expect(mail.subject).to include("Renew waste carrier registration")
        expect(mail.to).to eq([registration.contact_email])
        expect(mail.body.encoded).to include(registration.reg_identifier)
      end
    end
  end
end
