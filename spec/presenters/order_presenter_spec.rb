# frozen_string_literal: true

require "rails_helper"

RSpec.describe OrderPresenter do
  subject(:presenter) { described_class.new(order) }

  describe "#payment_method" do
    let(:registration) { create(:registration) }
    let(:order) { registration.finance_details.orders.first }

    it "returns the last order's payment method" do
      expect(presenter.payment_method).to eq("Card")
    end

    context "when no payment method yet exists" do
      before { order.update(paymentMethod: nil) }

      it "returns '-'" do
        expect(presenter.payment_method).to eq("-")
      end
    end
  end
end
