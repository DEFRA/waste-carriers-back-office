# frozen_string_literal: true

require "rails_helper"

RSpec.describe ContactEmailValidatorService do
  describe ".run" do
    let(:registration) { build(:registration) }

    subject { ContactEmailValidatorService.run(registration) }

    context "with a valid contact_email" do
      it "returns the contact_email" do
        expect(subject).to eq(registration.contact_email)
      end
    end

    context "without a contact_email" do
      before { registration.contact_email = "" }

      it "raises an error" do
        expect { subject }.to raise_error(Exceptions::MissingContactEmailError)
      end
    end

    context "without a contact_email that matches the AD email" do
      before { registration.contact_email = WasteCarriersEngine.configuration.assisted_digital_email }

      it "raises an error" do
        expect { subject }.to raise_error(Exceptions::AssistedDigitalContactEmailError)
      end
    end
  end
end
