# frozen_string_literal: true

require "rails_helper"

RSpec.describe PositiveChargeAdjustForm, type: :model do
  subject { described_class.new(build(:registration)) }

  describe "#submit" do
    context "when the form is valid" do
      let(:params) do
        {
          amount: "10.00",
          reference: "Reference",
          description: "Description"
        }
      end

      it "returns true" do
        expect(subject.submit(params)).to be_truthy
      end

      it "formats amount to be in cents" do
        subject.submit(params)

        expect(subject.amount).to eq(1000)
      end
    end

    context "when the form is not valid" do
      it "returns false" do
        expect(subject.submit({})).to be_falsey
      end
    end
  end
end
