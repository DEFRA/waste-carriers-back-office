# frozen_string_literal: true

require "rails_helper"

RSpec.describe PaymentPresenter do
  let(:finance_details) { double(:finance_details) }
  let(:payment) { double(:payment, finance_details: finance_details, order_key: "123") }
  let(:view) { nil }

  subject { described_class.new(payment, view) }

  describe ".create_from_collection" do
    it "given a list of objects, returns a list of instances of itself" do
      view = double(:view)

      object1 = double(:object1)
      object2 = double(:object2)

      presenter1 = double(:presenter1)
      presenter2 = double(:presenter2)

      collection = [object1, object2]

      expect(described_class).to receive(:new).with(object1, view).and_return(presenter1)
      expect(described_class).to receive(:new).with(object2, view).and_return(presenter2)

      expect(described_class.create_from_collection(collection, view)).to eq([presenter1, presenter2])
    end
  end

  describe "#already_refunded?" do
    before do
      scope = double(:scope)

      expect(finance_details).to receive(:payments).and_return(scope)
      expect(scope).to receive(:where).with(order_key: "123_REFUNDED").and_return([refunded_payment])
    end

    context "if a refunded payment exist for that order key" do
      let(:refunded_payment) { double(:refunded_payment) }

      it "returns true" do
        expect(subject).to be_already_refunded
      end
    end

    context "if a refunded payment do not exist for that order key" do
      let(:refunded_payment) {}

      it "returns false" do
        expect(subject).to_not be_already_refunded
      end
    end
  end

  describe "#already_reversed?" do
    before do
      scope = double(:scope)

      expect(finance_details).to receive(:payments).and_return(scope)
      expect(scope).to receive(:where).with(order_key: "123_REVERSAL").and_return([reversed_payment])
    end

    context "if a reversal payment exist for that order key" do
      let(:reversed_payment) { double(:reversed_payment) }

      it "returns true" do
        expect(subject).to be_already_reversed
      end
    end

    context "if a reversal payment do not exist for that order key" do
      let(:reversed_payment) {}

      it "returns false" do
        expect(subject).to_not be_already_reversed
      end
    end
  end

  describe "#no_action_message" do
    let(:reversed_payment) { double(:reversed_payment) }

    before do
      allow(subject).to receive(:already_reversed?).and_return(already_reversed)
    end

    context "when the payment was already reversed" do
      let(:already_reversed) { true }

      it "returns an already reversed message" do
        result = double(:result)

        expect(I18n).to receive(:t).with(".reversal_forms.index.already_reversed").and_return(result)
        expect(subject.no_action_message).to eq(result)
      end
    end

    context "when the payment was not reversed" do
      let(:already_reversed) { false }

      it "returns an already reversed message" do
        result = double(:result)

        expect(I18n).to receive(:t).with(".reversal_forms.index.not_applicable").and_return(result)
        expect(subject.no_action_message).to eq(result)
      end
    end
  end

  describe "#reversible?" do
    let(:user) { double(:user) }
    let(:view) { double(:view, current_user: user) }

    before do
      allow(user).to receive(:can?).with(:reverse, payment).and_return(can)
    end

    context "when current user cannot reverse the object" do
      let(:can) { false }

      it "returns false" do
        expect(subject).to_not be_reversible
      end
    end

    context "when current user can reverse the object" do
      let(:can) { true }

      before do
        allow(subject).to receive(:already_reversed?).and_return(already_reversed)
      end

      context "when the payment is already reversed" do
        let(:already_reversed) { true }

        it "returns false" do
          expect(subject).to_not be_reversible
        end
      end

      context "when the payment has not been reversed yet" do
        let(:already_reversed) { false }

        it "returns true" do
          expect(subject).to be_reversible
        end
      end
    end

  end

  describe "#refunded_message" do
    let(:world_pay_payment_status) { "world_pay_payment_status" }
    let(:refunded_payment) { double(:refunded_payment) }

    before do
      scope = double(:scope)

      allow(finance_details).to receive(:payments).and_return(scope)
      allow(scope).to receive(:where).with(order_key: "123_REFUNDED").and_return([refunded_payment])

      allow(payment).to receive(:online?).and_return(worldpay)
      allow(refunded_payment).to receive(:world_pay_payment_status).and_return(world_pay_payment_status)
    end

    context "when the payment is a card paymend" do
      let(:worldpay) { true }

      it "returns a card payment refunded message" do
        result = double(:result)

        expect(I18n).to receive(:t).with(".refunds.refunded_message.card", refund_status: world_pay_payment_status).and_return(result)
        expect(subject.refunded_message).to eq(result)
      end
    end

    context "when the payment is a cash payment" do
      let(:worldpay) { false }

      it "returns a cash payment refunded message" do
        result = double(:result)

        expect(I18n).to receive(:t).with(".refunds.refunded_message.manual").and_return(result)
        expect(subject.refunded_message).to eq(result)
      end

    end
  end
end
