# frozen_string_literal: true

require "rails_helper"

RSpec.describe FinanceDetailsHelper do
  describe "#display_pence_as_pounds_and_cents" do
    it "returns a formatted string from a float number with two decimal places" do
      expect(helper.display_pence_as_pounds_and_cents(1000)).to eq("10.00")
      expect(helper.display_pence_as_pounds_and_cents(1045)).to eq("10.45")
    end
  end

  describe "#details_path_for" do
    it "returns the path to the registration's details page" do
      allow(helper).to receive(:registration_path).and_return(:registration_path)

      expect(helper.details_path_for(WasteCarriersEngine::Registration.new)).to eq(:registration_path)
    end

    context "when the resource is a RenewingRegistration" do
      it "returns the pat to the renewing registration details page" do
        allow(helper).to receive(:renewing_registration_path).and_return(:renewing_registration_path)

        expect(helper.details_path_for(WasteCarriersEngine::RenewingRegistration.new)).to eq(:renewing_registration_path)
      end
    end
  end
end
