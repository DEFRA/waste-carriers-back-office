# frozen_string_literal: true

RSpec.shared_examples "agency_with_refund examples" do
  it "is able to view revoked reasons" do
    expect(subject).to be_able_to(:view_revoked_reasons, WasteCarriersEngine::RenewingRegistration)
  end

  it "is able to refund a payment" do
    expect(subject).to be_able_to(:refund, WasteCarriersEngine::Registration)
  end

  it "is able to cease a registration" do
    expect(subject).to be_able_to(:cease, WasteCarriersEngine::Registration)
  end

  it "is able to record a cash payment" do
    expect(subject).to be_able_to(:record_cash_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "is able to record a cheque payment" do
    expect(subject).to be_able_to(:record_cheque_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "is able to cancel a resource" do
    expect(subject).to be_able_to(:cancel, WasteCarriersEngine::Registration)
  end

  it "is able to record a postal order payment" do
    expect(subject).to be_able_to(:record_postal_order_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "is able to view payments" do
    expect(subject).to be_able_to(:view_payments, WasteCarriersEngine::RenewingRegistration)
  end

  context "when action is :reverse" do
    context "when the payment is a cash payment" do
      let(:payment) { build(:payment, :cash) }

      it "is able to reverse the payment" do
        expect(subject).to be_able_to(:reverse, payment)
      end
    end

    context "when the payment is a cheque payment" do
      let(:payment) { build(:payment, :cheque) }

      it "is able to reverse the payment" do
        expect(subject).to be_able_to(:reverse, payment)
      end
    end

    context "when the payment is a postal order" do
      let(:payment) { build(:payment, :postal_order) }

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

  context "when action is :write_off_small" do
    let(:finance_details) { build(:finance_details, balance: balance) }

    context "when the zero-difference balance is less than the write-off cap for agency users" do
      let(:balance) { WasteCarriersBackOffice::Application.config.write_off_agency_user_cap.to_i - 1 }

      it "is able to write off" do
        expect(subject).to be_able_to(:write_off_small, finance_details)
      end
    end

    context "when the zero-difference balance is more than the write-off cap for agency users" do
      let(:balance) { WasteCarriersBackOffice::Application.config.write_off_agency_user_cap.to_i + 1 }

      it "is not able to write off" do
        expect(subject).not_to be_able_to(:write_off_small, finance_details)
      end
    end

    context "when the zero-difference balance is equal to the write-off cap for agency users" do
      let(:balance) { WasteCarriersBackOffice::Application.config.write_off_agency_user_cap.to_i }

      it "is able to write off" do
        expect(subject).to be_able_to(:write_off_small, finance_details)
      end
    end
  end

  it "is able to revoke a registration" do
    expect(subject).to be_able_to(:revoke, WasteCarriersEngine::Registration)
  end
end
