# frozen_string_literal: true

RSpec.shared_examples "finance_admin examples" do
  # finance_admin and finance_super users should be able to do this:

  it "should be able to record a worldpay payment" do
    should be_able_to(:record_worldpay_missed_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "should be able to view the certificate" do
    should be_able_to(:view_certificate, WasteCarriersEngine::Registration)
  end

  it "should be able to view payments" do
    should be_able_to(:view_payments, WasteCarriersEngine::RenewingRegistration)
  end

  context ":reverse" do
    context "when the payment is a worldpay" do
      let(:payment) { build(:payment, :worldpay) }

      it "should be able to reverse the payment" do
        should be_able_to(:reverse, payment)
      end
    end

    context "when the payment is a worldpay_missed" do
      let(:payment) { build(:payment, :worldpay_missed) }

      it "should be able to reverse the payment" do
        should be_able_to(:reverse, payment)
      end
    end

    context "when the payment is another type" do
      let(:payment) { build(:payment) }

      it "should not be able to reverse the payment" do
        should_not be_able_to(:reverse, payment)
      end
    end
  end

  it "should be able to charge adjust a resource" do
    should be_able_to(:charge_adjust, WasteCarriersEngine::RenewingRegistration)
    should be_able_to(:charge_adjust, WasteCarriersEngine::Registration)
  end

  # finance_admin and finance_super users should not be able to do this:

  it "should not be able to update a transient registration" do
    should_not be_able_to(:update, WasteCarriersEngine::RenewingRegistration)
  end

  it "should be able to write off large finance details" do
    should be_able_to(:write_off_large, WasteCarriersEngine::FinanceDetails)
  end

  it "should not be able to write off small finance details" do
    should_not be_able_to(:write_off_small, WasteCarriersEngine::FinanceDetails)
  end

  it "should not be able to renew" do
    should_not be_able_to(:renew, WasteCarriersEngine::RenewingRegistration)
    should_not be_able_to(:renew, WasteCarriersEngine::Registration)
  end

  it "should not be able to record a cash payment" do
    should_not be_able_to(:record_cash_payment, WasteCarriersEngine::RenewingRegistration)
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

  it "should not be able to edit a registration" do
    should_not be_able_to(:edit, WasteCarriersEngine::Registration)
  end

  it "should not be able to record a cheque payment" do
    should_not be_able_to(:record_cheque_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to record a postal order payment" do
    should_not be_able_to(:record_postal_order_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to record a bank transfer payment" do
    should_not be_able_to(:record_bank_transfer_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to review convictions" do
    should_not be_able_to(:review_convictions, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to view revoked reasons" do
    should_not be_able_to(:view_revoked_reasons, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to revert to payment summary" do
    should_not be_able_to(:revert_to_payment_summary, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to transfer a registration" do
    should_not be_able_to(:transfer_registration, WasteCarriersEngine::Registration)
  end

  it "should not be able to modify agency users" do
    user = build(:user, :agency)
    should_not be_able_to(:modify_user, user)
  end
end
