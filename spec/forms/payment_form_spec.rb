# frozen_string_literal: true

require "rails_helper"

RSpec.describe PaymentForm do
  describe "#submit" do
    context "when params are valid" do
      let(:params) { { payment_type: "foo" } }

      it "returns true" do
        expect(subject.submit(params)).to be_truthy
      end
    end

    context "when params are invalid" do
      it "returns false" do
        expect(subject.submit({})).to be_falsey
      end
    end
  end
end
