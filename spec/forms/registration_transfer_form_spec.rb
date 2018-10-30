# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationTransferForm, type: :model do
  let(:registration_transfer_form) { build(:registration_transfer_form) }

  describe "#submit" do
    context "when the form is valid" do
      let(:valid_params) do
        {
          reg_identifier: registration_transfer_form.reg_identifier,
          email: registration_transfer_form.email,
          confirm_email: registration_transfer_form.confirm_email
        }
      end

      it "should submit" do
        expect(registration_transfer_form.submit(valid_params)).to eq(true)
      end
    end

    context "when the form is not valid" do
      let(:invalid_params) do
        {
          reg_identifier: nil,
          email: nil,
          confirm_email: nil
        }
      end

      it "should not submit" do
        expect(registration_transfer_form.submit(invalid_params)).to eq(false)
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
      before { registration_transfer_form.confirm_email = "no_matchy@example.com" }

      it "is not valid" do
        expect(registration_transfer_form).to_not be_valid
      end
    end
  end
end
