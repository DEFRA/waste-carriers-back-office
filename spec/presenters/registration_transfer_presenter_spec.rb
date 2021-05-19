# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationTransferPresenter do
  let(:registration) { double(:registration, account_email: account_email) }
  let(:presenter) { described_class.new(registration) }

  context "account_email messages" do
    context "with an account_email" do
      let(:account_email) { "alice@example.com" }

      it "returns the paragraph_1 message" do
        expect(presenter.paragraph_1_message)
          .to eq("This registration currently belongs to alice@example.com.")
      end

      it "returns the account_email" do
        expect(presenter.account_email_message).to eq("alice@example.com")
      end
    end

    context "without an account_email" do
      let(:account_email) { "" }

      it "returns the paragraph_1_no_email message" do
        expect(presenter.paragraph_1_message)
          .to eq("This registration currently does not have an account associated with it.")
      end

      it "returns n/a" do
        expect(presenter.account_email_message)
          .to eq("n/a")
      end
    end
  end
end
