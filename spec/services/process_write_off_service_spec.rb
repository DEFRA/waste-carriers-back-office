# frozen_string_literal: true

require "rails_helper"

RSpec.describe ProcessWriteOffService do
  describe ".run" do
    let(:zero_difference_balance) { 4 }
    let(:balance) { 4 }
    let(:payments) { double(:payments) }
    let(:unpaid_balance) { 4 }
    let(:finance_details) do
      double(
        :finance_details,
        zero_difference_balance: zero_difference_balance,
        balance: balance,
        unpaid_balance: unpaid_balance,
        payments: payments
      )
    end
    let(:comment) { double(:comment) }
    let(:user) { double(:user, email: double(:email)) }

    let(:result) { described_class.run(finance_details: finance_details, user: user, comment: comment) }

    context "when the balance is 0" do
      let(:balance) { 0 }

      it "returns false" do
        expect(result).to be(false)
      end
    end

    context "when the balance is different from 0" do
      before do
        allow(user).to receive(:can?).with(:write_off_large, finance_details).and_return(can)
      end

      context "when the user has write_off_large permissions" do
        let(:can) { true }

        it "generates a new write off large payment and assigns it to the finance details" do
          write_off = double(:write_off)

          allow(WasteCarriersEngine::Payment).to receive(:new).with(payment_type: "WRITEOFFLARGE").and_return(write_off)
          expect(write_off).to receive(:order_key=)
          expect(write_off).to receive(:amount=).with(4)
          expect(write_off).to receive(:date_entered=)
          expect(write_off).to receive(:date_received=)
          expect(write_off).to receive(:registration_reference=)
          expect(write_off).to receive(:updated_by_user=).with(user.email)
          expect(write_off).to receive(:comment=).with(comment)

          expect(payments).to receive(:<<).with(write_off)
          expect(finance_details).to receive(:update_balance)
          expect(finance_details).to receive(:save!)

          result
        end
      end

      context "when the user does not have write_off_large permissions" do
        let(:can) { false }

        it "generates a new write off small payment and assigns it to the finance details" do
          write_off = double(:write_off)

          allow(WasteCarriersEngine::Payment).to receive(:new).with(payment_type: "WRITEOFFSMALL").and_return(write_off)
          expect(write_off).to receive(:order_key=)
          expect(write_off).to receive(:amount=).with(4)
          expect(write_off).to receive(:date_entered=)
          expect(write_off).to receive(:date_received=)
          expect(write_off).to receive(:registration_reference=)
          expect(write_off).to receive(:updated_by_user=).with(user.email)
          expect(write_off).to receive(:comment=).with(comment)

          expect(payments).to receive(:<<).with(write_off)
          expect(finance_details).to receive(:update_balance)
          expect(finance_details).to receive(:save!)

          result
        end
      end

      context "when the registration is in debit" do
        let(:can) { true }
        let(:balance) { -4 }
        let(:unpaid_balance) { 0 }
        let(:zero_difference_balance) { 4 }

        it "generates a new write off payment in credit and assigns it to the finance details" do
          write_off = double(:write_off)

          allow(WasteCarriersEngine::Payment).to receive(:new).and_return(write_off)
          expect(write_off).to receive(:order_key=)
          expect(write_off).to receive(:amount=).with(-4)
          expect(write_off).to receive(:date_entered=)
          expect(write_off).to receive(:date_received=)
          expect(write_off).to receive(:registration_reference=)
          expect(write_off).to receive(:updated_by_user=).with(user.email)
          expect(write_off).to receive(:comment=).with(comment)

          expect(payments).to receive(:<<).with(write_off)
          expect(finance_details).to receive(:update_balance)
          expect(finance_details).to receive(:save!)

          result
        end
      end
    end
  end
end
