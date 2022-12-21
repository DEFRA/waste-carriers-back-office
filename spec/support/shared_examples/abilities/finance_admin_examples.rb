# frozen_string_literal: true

RSpec.shared_examples "finance_admin examples" do
  # finance_admin and finance_super users should be able to do this:

  it "is able to record a worldpay payment" do
    expect(subject).to be_able_to(:record_worldpay_missed_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "is able to view the certificate" do
    expect(subject).to be_able_to(:view_certificate, WasteCarriersEngine::Registration)
  end

  it "is able to view payments" do
    expect(subject).to be_able_to(:view_payments, WasteCarriersEngine::RenewingRegistration)
  end

  context "when action is :reverse" do
    context "when the payment is a worldpay" do
      let(:payment) { build(:payment, :worldpay) }

      it "is able to reverse the payment" do
        expect(subject).to be_able_to(:reverse, payment)
      end
    end

    context "when the payment is a worldpay_missed" do
      let(:payment) { build(:payment, :worldpay_missed) }

      it "is able to reverse the payment" do
        expect(subject).to be_able_to(:reverse, payment)
      end
    end

    context "when the payment is another type" do
      let(:payment) { build(:payment) }

      it "is not able to reverse the payment" do
        expect(subject).not_to be_able_to(:reverse, payment)
      end
    end
  end

  it "is able to charge adjust a resource" do
    expect(subject).to be_able_to(:charge_adjust, WasteCarriersEngine::RenewingRegistration)
    expect(subject).to be_able_to(:charge_adjust, WasteCarriersEngine::Registration)
  end

  # finance_admin and finance_super users should not be able to do this:

  it "is not able to update a transient registration" do
    expect(subject).not_to be_able_to(:update, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to create a registration" do
    expect(subject).not_to be_able_to(:create, WasteCarriersEngine::Registration)
  end

  it "is able to write off large finance details" do
    expect(subject).to be_able_to(:write_off_large, WasteCarriersEngine::FinanceDetails)
  end

  it "is not able to write off small finance details" do
    expect(subject).not_to be_able_to(:write_off_small, WasteCarriersEngine::FinanceDetails)
  end

  it "is not able to renew" do
    expect(subject).not_to be_able_to(:renew, WasteCarriersEngine::RenewingRegistration)
    expect(subject).not_to be_able_to(:renew, WasteCarriersEngine::Registration)
  end

  it "is not able to record a cash payment" do
    expect(subject).not_to be_able_to(:record_cash_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to refund a payment" do
    expect(subject).not_to be_able_to(:refund, WasteCarriersEngine::Registration)
  end

  it "is not able to cease a registration" do
    expect(subject).not_to be_able_to(:cease, WasteCarriersEngine::Registration)
  end

  it "is not able to revoke a registration" do
    expect(subject).not_to be_able_to(:revoke, WasteCarriersEngine::Registration)
  end

  it "is not able to edit a registration" do
    expect(subject).not_to be_able_to(:edit, WasteCarriersEngine::Registration)
  end

  it "is not able to record a cheque payment" do
    expect(subject).not_to be_able_to(:record_cheque_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to record a postal order payment" do
    expect(subject).not_to be_able_to(:record_postal_order_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to record a bank transfer payment" do
    expect(subject).not_to be_able_to(:record_bank_transfer_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to review convictions" do
    expect(subject).not_to be_able_to(:review_convictions, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to view revoked reasons" do
    expect(subject).not_to be_able_to(:view_revoked_reasons, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to revert to payment summary" do
    expect(subject).not_to be_able_to(:revert_to_payment_summary, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to transfer a registration" do
    expect(subject).not_to be_able_to(:transfer_registration, WasteCarriersEngine::Registration)
  end

  it "is not able to modify agency users" do
    user = build(:user, role: :agency)
    expect(subject).not_to be_able_to(:modify_user, user)
  end
end
