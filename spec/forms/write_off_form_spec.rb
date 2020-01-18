# frozen_string_literal: true

require "rails_helper"

RSpec.describe WriteOffForm do
  subject { described_class.new(build(:renewing_registration)) }

  describe "#submit" do
    before do
      allow(subject).to receive(:valid?).and_return(valid)
    end

    context "when the object is valid" do
      let(:valid) { true }
      # TODO
    end

    context "when the object is invalid" do
      let(:valid) { false }

      it "returns false" do
        expect(subject.submit({})).to eq(false)
      end
    end
  end
end
