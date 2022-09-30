# frozen_string_literal: true

RSpec.shared_examples "finance examples" do
  # Finance users can only do two things:
  it "is able to record a bank transfer payment" do
    is_expected.to be_able_to(:record_bank_transfer_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to charge adjust a resource" do
    is_expected.not_to be_able_to(:charge_adjust, WasteCarriersEngine::RenewingRegistration)
    is_expected.not_to be_able_to(:charge_adjust, WasteCarriersEngine::Registration)
  end

  it "is able to view payments" do
    is_expected.to be_able_to(:view_payments, WasteCarriersEngine::RenewingRegistration)
  end

  it "is able to view the certificate" do
    is_expected.to be_able_to(:view_certificate, WasteCarriersEngine::Registration)
  end

  context "when action is :reverse" do
    context "when the payment is a bank transfer" do
      let(:payment) { build(:payment, :bank_transfer) }

      it "is able to reverse the payment" do
        is_expected.to be_able_to(:reverse, payment)
      end
    end

    context "when the payment is another type" do
      let(:payment) { build(:payment) }

      it "is not able to reverse the payment" do
        is_expected.not_to be_able_to(:reverse, payment)
      end
    end
  end

  # Everything else is off-limits.

  it "is not able to cancel a resource" do
    is_expected.not_to be_able_to(:cancel, WasteCarriersEngine::Registration)
  end

  it "is not able to update a transient registration" do
    is_expected.not_to be_able_to(:update, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to create a registration" do
    is_expected.not_to be_able_to(:create, WasteCarriersEngine::Registration)
  end

  it "is not able to write off large finance details" do
    is_expected.not_to be_able_to(:write_off_large, WasteCarriersEngine::FinanceDetails)
  end

  it "is not able to write off small finance details" do
    is_expected.not_to be_able_to(:write_off_small, WasteCarriersEngine::FinanceDetails)
  end

  it "is not able to renew" do
    is_expected.not_to be_able_to(:renew, WasteCarriersEngine::RenewingRegistration)
    is_expected.not_to be_able_to(:renew, WasteCarriersEngine::Registration)
  end

  it "is not able to record a cash payment" do
    is_expected.not_to be_able_to(:record_cash_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to refund a payment" do
    is_expected.not_to be_able_to(:refund, WasteCarriersEngine::Registration)
  end

  it "is not able to record a cheque payment" do
    is_expected.not_to be_able_to(:record_cheque_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to cease a registration" do
    is_expected.not_to be_able_to(:cease, WasteCarriersEngine::Registration)
  end

  it "is not able to revoke a registration" do
    is_expected.not_to be_able_to(:revoke, WasteCarriersEngine::Registration)
  end

  it "is not able to edit a registration" do
    is_expected.not_to be_able_to(:edit, WasteCarriersEngine::Registration)
  end

  it "is not able to record a postal order payment" do
    is_expected.not_to be_able_to(:record_postal_order_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to record a worldpay payment" do
    is_expected.not_to be_able_to(:record_worldpay_missed_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to review convictions" do
    is_expected.not_to be_able_to(:review_convictions, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to view revoked reasons" do
    is_expected.not_to be_able_to(:view_revoked_reasons, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to revert to payment summary" do
    is_expected.not_to be_able_to(:revert_to_payment_summary, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to transfer a registration" do
    is_expected.not_to be_able_to(:transfer_registration, WasteCarriersEngine::Registration)
  end

  it "is not able to manage back office users" do
    is_expected.not_to be_able_to(:manage_back_office_users, User)
  end

  it "is not able to modify agency users" do
    user = build(:user, :agency)
    is_expected.not_to be_able_to(:modify_user, user)
  end

  it "is not able to modify finance users" do
    user = build(:user, :finance)
    is_expected.not_to be_able_to(:modify_user, user)
  end
end
