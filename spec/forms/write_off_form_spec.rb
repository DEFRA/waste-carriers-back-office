# frozen_string_literal: true

require "rails_helper"

RSpec.describe WriteOffForm do
  subject { described_class.new(renewing_registration) }

  let(:renewing_registration) { build(:renewing_registration) }
  let(:user) { double(:user) }

  describe "#submit" do
    context "when the object is valid" do
      it "returns true" do
        comment = double(:comment)

        expect(subject.submit(comment: comment)).to be(true)
      end
    end

    context "when the object is invalid" do
      it "returns false" do
        expect(subject.submit({})).to be(false)
      end
    end
  end
end
