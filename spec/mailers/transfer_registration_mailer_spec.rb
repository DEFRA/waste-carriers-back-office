# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe RegistrationTransferMailer, type: :mailer do
    before do
      allow(Rails.configuration).to receive(:email_service_email).and_return("test@example.com")
    end

    describe "transfer_to_existing_account_email" do
      let(:registration) { create(:registration) }
      let(:mail) { RegistrationTransferMailer.transfer_to_existing_account_email(registration) }

      it "uses the correct 'to' address" do
        expect(mail.to).to eq([registration.account_email])
      end

      it "uses the correct 'from' address" do
        expect(mail.from).to eq(["test@example.com"])
      end

      it "uses the correct subject" do
        subject = "The waste carriers registration #{registration.reg_identifier} has been transferred to you"
        expect(mail.subject).to eq(subject)
      end

      it "includes the correct reg_identifier in the body" do
        expect(mail.body.encoded).to include(registration.reg_identifier)
      end
    end

    describe "transfer_to_new_account_email" do
      let(:registration) { create(:registration) }
      let(:mail) { RegistrationTransferMailer.transfer_to_new_account_email(registration) }

      it "uses the correct 'to' address" do
        expect(mail.to).to eq([registration.account_email])
      end

      it "uses the correct 'from' address" do
        expect(mail.from).to eq(["test@example.com"])
      end

      it "uses the correct subject" do
        subject = "The waste carriers registration #{registration.reg_identifier} has been transferred to you"
        expect(mail.subject).to eq(subject)
      end

      it "includes the correct reg_identifier in the body" do
        expect(mail.body.encoded).to include(registration.reg_identifier)
      end
    end
  end
end
