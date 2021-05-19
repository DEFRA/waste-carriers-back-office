# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationTransferPresenter do
  let(:registration) do
    double(:registration, account_email: account_email, reg_identifier: "ABC1")
  end

  let(:presenter) { described_class.new(registration) }

  context "account_email messages" do
    context "with an account_email" do
      let(:account_email) { "alice@example.com" }

      it "returns the new_registration_transfer_message_lines" do
        expect(presenter.new_registration_transfer_message_lines)
          .to eq(
            [
              message_for(:paragraph_1, email: account_email),
              message_for(:paragraph_2, reg_identifier: registration.reg_identifier),
              message_for(:paragraph_3, email: account_email),
              message_for(:paragraph_4, email: account_email)
            ]
          )
      end

      it "returns the account_email" do
        expect(presenter.account_email_message).to eq("alice@example.com")
      end
    end

    context "without an account_email" do
      let(:account_email) { "" }

      it "returns the paragraph_1_no_email message" do
        expect(presenter.new_registration_transfer_message_lines)
          .to eq(
            [
              message_for(:paragraph_1_no_account_email),
              message_for(:paragraph_2, reg_identifier: registration.reg_identifier)
            ]
          )
      end

      it "returns n/a" do
        expect(presenter.account_email_message).to eq("n/a")
      end
    end

    def message_for(key, options = {})
      I18n.t(".registration_transfers.new.#{key}", options)
    end
  end
end
