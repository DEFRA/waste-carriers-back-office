# frozen_string_literal: true

RSpec.shared_examples "below agency_with_refund examples" do
  it "should not be able to view revoked reasons" do
    should_not be_able_to(:view_revoked_reasons, WasteCarriersEngine::RenewingRegistration)
  end

  context ":reverse" do
    context "when the payment is a cash payment" do
      let(:payment) { build(:payment, :cash) }

      it "should not be able to reverse the payment" do
        should_not be_able_to(:reverse, payment)
      end
    end

    context "when the payment is a cheque payment" do
      let(:payment) { build(:payment, :cheque) }

      it "should not be able to reverse the payment" do
        should_not be_able_to(:reverse, payment)
      end
    end

    context "when the payment is a postal order" do
      let(:payment) { build(:payment, :postal_order) }

      it "should not be able to reverse the payment" do
        should_not be_able_to(:reverse, payment)
      end
    end

    context "when the payment is another type" do
      let(:payment) { build(:payment) }

      it "should not be able to reverse the payment" do
        should_not be_able_to(:reverse, payment)
      end
    end
  end

  it "should not be able to view payments" do
    should_not be_able_to(:view_payments, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to refund a payment" do
    should_not be_able_to(:refund, WasteCarriersEngine::Registration)
  end

  it "should not be able to cease a registration" do
    should_not be_able_to(:cease, WasteCarriersEngine::Registration)
  end

  it "should not be able to revoke a registration" do
    should_not be_able_to(:revoke, WasteCarriersEngine::Registration)
  end

  it "should not be able to record a cash payment" do
    should_not be_able_to(:record_cash_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to record a cheque payment" do
    should_not be_able_to(:record_cheque_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to record a postal order payment" do
    should_not be_able_to(:record_postal_order_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to write off small" do
    should_not be_able_to(:write_off_small, WasteCarriersEngine::FinanceDetails)
  end
end
