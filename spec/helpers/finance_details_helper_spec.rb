# frozen_string_literal: true

require "rails_helper"

RSpec.describe FinanceDetailsHelper, type: :helper do
  describe "#display_pence_as_pounds_and_cents" do
    it "returns a formatted string from a float number with two decimal places" do
      expect(helper.display_pence_as_pounds_and_cents(1000)).to eq("10.00")
      expect(helper.display_pence_as_pounds_and_cents(1045)).to eq("10.45")
    end
  end
end
