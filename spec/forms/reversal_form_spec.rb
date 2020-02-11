# frozen_string_literal: true

require "rails_helper"

RSpec.describe ReversalForm do
  describe "#submit" do
    subject { described_class.new(build(:renewing_registration)) }

    context "when the params are valid" do
      let(:params) { { reason: "A reason" } }

      it "returns true" do
        expect(subject.submit(params)).to be_truthy
      end
    end

    context "when the params are not valid" do
      let(:params) { { reason: nil } }

      it "returns false" do
        expect(subject.submit(params)).to be_falsey
      end
    end
  end
end
