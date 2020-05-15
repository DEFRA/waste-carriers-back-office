# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewalReminderMailer, type: :mailer do
  before do
    allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:renew_via_magic_link).and_return(true)
  end

  describe ".first_reminder_email" do
    let(:registration) { create(:registration, expires_on: 3.days.from_now) }

    before do
      allow(Rails.configuration).to receive(:email_service_email).and_return("test@example.com")
    end

    it "sends a first reminder email" do
      mail = described_class.first_reminder_email(registration)

      expect(registration).to receive(:generate_renew_token!)
      expect(mail.subject).to include("Renew waste carrier registration")
      expect(mail.to).to eq([registration.contact_email])
      expect(mail.to).to eq([registration.account_email])
      expect(mail.body.encoded).to include(registration.reg_identifier)
    end
  end

  describe ".second_reminder_email" do
    let(:registration) { create(:registration, expires_on: 3.days.from_now) }

    before do
      allow(Rails.configuration).to receive(:email_service_email).and_return("test@example.com")
    end

    it "sends a second reminder email" do
      mail = described_class.second_reminder_email(registration)

      expect(registration).to receive(:generate_renew_token!)
      expect(mail.subject).to include("Renew waste carrier registration")
      expect(mail.to).to eq([registration.contact_email])
      expect(mail.to).to eq([registration.account_email])
      expect(mail.body.encoded).to include(registration.reg_identifier)
    end
  end
end
