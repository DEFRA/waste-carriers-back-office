# frozen_string_literal: true

require "rails_helper"

RSpec.describe ChargeAdjustStartForm, type: :model do
  subject { described_class.new(build(:registration)) }

  describe "#submit" do
    context "when the form is valid" do
      let(:params) do
        {
          charge_type: "positive"
        }
      end

      it "returns true" do
        expect(subject.submit(params)).to be_truthy
      end
    end

    context "When the form is not valid" do
      it "returns false" do
        expect(subject.submit({})).to be_falsey
      end
    end
  end
end
