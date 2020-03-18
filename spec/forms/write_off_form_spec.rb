# frozen_string_literal: true

require "rails_helper"

RSpec.describe WriteOffForm do
  let(:renewing_registration) { build(:renewing_registration) }
  let(:user) { double(:user) }
  subject { described_class.new(renewing_registration) }

  describe "#submit" do
    before do
      allow(subject).to receive(:valid?).and_return(valid)
    end

    context "when the object is valid" do
      let(:valid) { true }

      it "returns true" do
        comment = double(:comment)

        expect(subject.submit(comment: comment)).to eq(true)
      end
    end

    context "when the object is invalid" do
      let(:valid) { false }

      it "returns false" do
        expect(subject.submit({})).to eq(false)
      end
    end
  end
end
