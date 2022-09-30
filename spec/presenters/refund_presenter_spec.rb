# frozen_string_literal: true

require "rails_helper"

RSpec.describe RefundPresenter do
  subject { described_class.new(finance_details, payment) }

  let(:finance_details) { double(:finance_details) }
  let(:payment) { double(:payment) }

  describe ".total_amount_paid" do
    let(:payment1) { double(:payment, amount: 100) }
    let(:payment2) { double(:payment, amount: 600) }
    let(:finance_details) { double(:finance_details, payments: [payment1, payment2]) }

    it "returns the total of all payments made by a user to a registration" do
      expect(subject.total_amount_paid).to eq(700)
    end
  end

  describe ".total_amount_due" do
    let(:order1) { double(:order, total_amount: 100) }
    let(:order2) { double(:order, total_amount: 600) }
    let(:finance_details) { double(:finance_details, orders: [order1, order2]) }

    it "returns the total amount of all orders made by a user to a registration" do
      expect(subject.total_amount_due).to eq(700)
    end
  end

  describe ".balance_to_refund" do
    let(:finance_details) { double(:finance_details, balance: -300) }

    context "when the payment amount is less than the overpaid amoun" do
      let(:payment) { double(:payment, amount: 200) }

      it "returns the payment amount" do
        expect(subject.balance_to_refund).to eq(200)
      end
    end

    context "when the overpaid amount is less than the payment amount" do
      let(:payment) { double(:payment, amount: 700) }

      it "returns the overpaid amount" do
        expect(subject.balance_to_refund).to eq(300)
      end
    end
  end
end
