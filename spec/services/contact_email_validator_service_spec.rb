# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContactEmailValidatorService do
  describe ".run" do
    let(:registration) { build(:registration, contact_email: contact_email) }

    subject { ContactEmailValidatorService.run(registration) }

    context "with a valid contact_email" do
      let(:contact_email) { "alice@example.com" }

      it "returns the contact_email" do
        expect(subject).to eq(registration.contact_email)
      end
    end

    context "without a contact_email" do
      let(:contact_email) { "" }

      it "raises an error" do
        expect { subject }.to raise_error(Exceptions::MissingContactEmailError)
      end
    end
  end
end
