# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationTransferForm, type: :model do
  let(:registration_transfer_form) { build(:registration_transfer_form) }

  describe "#submit" do
    context "when the form is valid" do
      let(:valid_params) do
        {
          email: registration_transfer_form.email,
          confirm_email: registration_transfer_form.confirm_email
        }
      end

      before do
        allow(RegistrationTransferService).to receive(:run).and_return(:success_existing_user)
      end

      it "should submit" do
        expect(registration_transfer_form.submit(valid_params)).to eq(true)
      end
    end

    context "when the form is not valid" do
      let(:invalid_params) do
        {
          email: nil,
          confirm_email: nil
        }
      end

      it "should not submit" do
        expect(registration_transfer_form.submit(invalid_params)).to eq(false)
      end
    end

    context "when the params contain uppercase letters" do
      let(:uppercase_params) do
        {
          email: "UPPERCASElowercase@example.com",
          confirm_email: "UPPERCASElowercase@example.com"
        }
      end

      it "lowercases the email" do
        registration_transfer_form.submit(uppercase_params)
        expect(registration_transfer_form.email).to eq("uppercaselowercase@example.com")
      end

      it "lowercases the confirm_email" do
        registration_transfer_form.submit(uppercase_params)
        expect(registration_transfer_form.confirm_email).to eq("uppercaselowercase@example.com")
      end
    end
  end

  describe "#email" do
    context "when it's blank" do
      before do
        registration_transfer_form.email = ""
        registration_transfer_form.confirm_email = ""
      end

      it "is not valid" do
        expect(registration_transfer_form).to_not be_valid
      end
    end

    context "when it isn't in the correct format" do
      before do
        registration_transfer_form.email = "foo"
        registration_transfer_form.confirm_email = "foo"
      end

      it "is not valid" do
        expect(registration_transfer_form).to_not be_valid
      end
    end
  end

  describe "#confirm_email" do
    context "when it doesn't match the email" do
      let(:original_account_email) { registration_transfer_form.registration.account_email }

      before { registration_transfer_form.confirm_email = "no_matchy@example.com" }

      it "is not valid" do
        expect(registration_transfer_form).to_not be_valid
      end

      it "does not update the account_email" do
        expect(registration_transfer_form.registration.account_email).to eq(original_account_email)
      end
    end
  end
end
