# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationTransferForm, type: :model do
  describe "#submit" do
    context "when the form is valid" do
      let(:registration_transfer_form) { build(:registration_transfer_form) }
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
      let(:registration_transfer_form) { build(:registration_transfer_form) }
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
end
