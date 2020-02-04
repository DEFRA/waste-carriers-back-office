# frozen_string_literal: true

RSpec.shared_examples "agency examples" do
  # All agency users should be able to do this:

  it "should be able to update a transient registration" do
    should be_able_to(:update, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to charge adjust a resource" do
    should_not be_able_to(:charge_adjust, WasteCarriersEngine::RenewingRegistration)
    should_not be_able_to(:charge_adjust, WasteCarriersEngine::Registration)
  end

  it "should be able to renew" do
    should be_able_to(:renew, WasteCarriersEngine::RenewingRegistration)
    should be_able_to(:renew, WasteCarriersEngine::Registration)
  end

  it "should be able to review convictions" do
    should be_able_to(:review_convictions, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to write off large" do
    should_not be_able_to(:write_off_large, WasteCarriersEngine::FinanceDetails)
  end

  context ":write_off_small" do
    let(:finance_details) { build(:finance_details, balance: balance) }

    context "when the zero-difference balance is less than the write-off cap for agency users" do
      let(:balance) { WasteCarriersBackOffice::Application.config.write_off_agency_user_cap.to_i - 1 }

      it "should be able to write off" do
        should be_able_to(:write_off_small, finance_details)
      end
    end

    context "when the zero-difference balance is more than the write-off cap for agency users" do
      let(:balance) { WasteCarriersBackOffice::Application.config.write_off_agency_user_cap.to_i + 1 }

      it "should not be able to write off" do
        should_not be_able_to(:write_off_small, finance_details)
      end
    end

    context "when the zero-difference balance is equal to the write-off cap for agency users" do
      let(:balance) { WasteCarriersBackOffice::Application.config.write_off_agency_user_cap.to_i }

      it "should not be able to write off" do
        should_not be_able_to(:write_off_small, finance_details)
      end
    end
  end

  it "should be able to transfer a registration" do
    should be_able_to(:transfer_registration, WasteCarriersEngine::Registration)
  end

  it "should be able to revert to payment summary" do
    should be_able_to(:revert_to_payment_summary, WasteCarriersEngine::RenewingRegistration)
  end

  it "should be able to record a cash payment" do
    should be_able_to(:record_cash_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "should be able to record a cheque payment" do
    should be_able_to(:record_cheque_payment, WasteCarriersEngine::RenewingRegistration)
  end

  it "should be able to record a postal order payment" do
    should be_able_to(:record_postal_order_payment, WasteCarriersEngine::RenewingRegistration)
  end

  # All agency users should NOT be able to do this:

  it "should not be able to modify finance users" do
    user = build(:user, :finance)
    should_not be_able_to(:modify_user, user)
  end
end
