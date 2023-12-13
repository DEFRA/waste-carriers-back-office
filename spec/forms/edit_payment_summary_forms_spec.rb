# frozen_string_literal: true

require "rails_helper"

RSpec.describe EditPaymentSummaryForm do
  describe "#submit" do
    let(:edit_payment_summary_form) { build(:edit_payment_summary_form, :has_required_data) }

    context "when the form is valid" do
      let(:valid_params) do
        { temp_payment_method: "card" }
      end

      it "submits" do
        expect(edit_payment_summary_form.submit(valid_params)).to be true
      end
    end

    context "when the form is not valid" do
      before do
        allow(edit_payment_summary_form).to receive(:valid?).and_return(false)
      end

      it "does not submit" do
        expect(edit_payment_summary_form.submit({})).to be false
      end
    end
  end
end
