# frozen_string_literal: true

RSpec.shared_examples "below agency_with_refund examples" do
  it "is not able to view revoked reasons" do
    expect(subject).not_to be_able_to(:view_revoked_reasons, WasteCarriersEngine::RenewingRegistration)
  end

  context "when action is :reverse" do
    context "when the payment is a cash payment" do
      let(:payment) { build(:payment, :cash) }

      it "is not able to reverse the payment" do
        expect(subject).not_to be_able_to(:reverse, payment)
      end
    end

    context "when the payment is a cheque payment" do
      let(:payment) { build(:payment, :cheque) }

      it "is not able to reverse the payment" do
        expect(subject).not_to be_able_to(:reverse, payment)
      end
    end

    context "when the payment is a postal order" do
      let(:payment) { build(:payment, :postal_order) }

      it "is not able to reverse the payment" do
        expect(subject).not_to be_able_to(:reverse, payment)
      end
    end

    context "when the payment is another type" do
      let(:payment) { build(:payment) }

      it "is not able to reverse the payment" do
        expect(subject).not_to be_able_to(:reverse, payment)
      end
    end
  end

  it "is not able to cancel a resource" do
    expect(subject).not_to be_able_to(:cancel, WasteCarriersEngine::Registration)
  end

  it "is not able to view payments" do
    expect(subject).not_to be_able_to(:view_payments, WasteCarriersEngine::RenewingRegistration)
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

  it "is not able to record a cash payment" do
    expect(subject).not_to be_able_to(:record_cash_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to record a cheque payment" do
    expect(subject).not_to be_able_to(:record_cheque_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to record a postal order payment" do
    expect(subject).not_to be_able_to(:record_postal_order_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to write off small" do
    expect(subject).not_to be_able_to(:write_off_small, WasteCarriersEngine::FinanceDetails)
  end

  it "is not able to review convictions" do
    expect(subject).not_to be_able_to(:review_convictions, WasteCarriersEngine::RenewingRegistration)
  end
end
