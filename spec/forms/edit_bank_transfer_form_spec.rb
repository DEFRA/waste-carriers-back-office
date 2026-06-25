# frozen_string_literal: true

require "rails_helper"

RSpec.describe EditBankTransferForm do
  describe "#submit" do
    let(:edit_bank_transfer_form) { build(:edit_bank_transfer_form, :has_required_data) }

    context "when the form is valid" do
      it "submits" do
        expect(edit_bank_transfer_form.submit({})).to be true
      end
    end

    context "when the form is not valid" do
      before do
        allow(edit_bank_transfer_form).to receive(:valid?).and_return(false)
      end

      it "does not submit" do
        expect(edit_bank_transfer_form.submit({})).to be false
      end
    end
  end
end
