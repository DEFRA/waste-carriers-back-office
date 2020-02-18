# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChargeAdjustForm do
  describe "#submit" do
    context "when parameters are valid" do
      let(:params) { { charge_type: "positive" } }

      it "returns true" do
        expect(subject.submit(params)).to be_truthy
      end
    end

    context "when parameters are invalid" do
      let(:params) { { charge_type: "foo" } }

      it "returns true" do
        expect(subject.submit(params)).to be_falsey
      end
    end

    context "when parameters are empty" do
      it "returns false" do
        expect(subject.submit({})).to be_falsey
      end
    end
  end
end
