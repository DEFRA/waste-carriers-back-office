# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewalReminderMailer, type: :mailer do
  describe ".first_reminder_email" do
    let(:registration) { create(:registration) }

    before do
      allow(Rails.configuration).to receive(:email_service_email).and_return("test@example.com")
    end

    it "sends a first reminder email" do
      described_class.first_reminder_email(registration)

      expect(mail.to).to eq([registration.contact_email, registration.account_email])
      expect(mail.to).to eq([registration.account_email])
      expect(mail.body.encoded).to include(registration.reg_identifier)
    end
  end
end
