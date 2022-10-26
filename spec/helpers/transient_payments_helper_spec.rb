# frozen_string_literal: true

require "rails_helper"

RSpec.describe TransientPaymentsHelper do
  let(:transient_registration) { build(:renewing_registration) }

  before do
    assign(:transient_registration, transient_registration)
  end

  describe "#record_payment_of_type" do
    context "when a payment_type is provided" do
      it "returns a correctly_named symbol" do
        expect(helper.record_payment_of_type("cash")).to eq(:record_cash_payment)
      end
    end
  end
end
