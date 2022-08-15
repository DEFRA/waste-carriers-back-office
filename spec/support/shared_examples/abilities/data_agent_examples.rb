# frozen_string_literal: true

RSpec.shared_examples "data_agent examples" do

  it "should be able to view the certificate" do
    should be_able_to(:view_certificate, WasteCarriersEngine::Registration)
  end

  it "should be able to view revoked reasons" do
    should be_able_to(:view_revoked_reasons, WasteCarriersEngine::RenewingRegistration)
  end

  it "should not be able to do anything else" do
    should_not be_able_to(:cancel, WasteCarriersEngine::Registration)
    should_not be_able_to(:cease, WasteCarriersEngine::Registration)
    should_not be_able_to(:charge_adjust, WasteCarriersEngine::Registration)
    should_not be_able_to(:charge_adjust, WasteCarriersEngine::RenewingRegistration)
    should_not be_able_to(:create, WasteCarriersEngine::Registration)
    should_not be_able_to(:edit, WasteCarriersEngine::Registration)
    should_not be_able_to(:import_conviction_data, :all)
    should_not be_able_to(:manage, WasteCarriersEngine::FeatureToggle)
    should_not be_able_to(:manage_back_office_users, User)
    should_not be_able_to(:modify_user, user)
    should_not be_able_to(:record_bank_transfer_payment, WasteCarriersEngine::RenewingRegistration)
    should_not be_able_to(:record_cash_payment, WasteCarriersEngine::RenewingRegistration)
    should_not be_able_to(:record_cheque_payment, WasteCarriersEngine::RenewingRegistration)
    should_not be_able_to(:record_postal_order_payment, WasteCarriersEngine::RenewingRegistration)
    should_not be_able_to(:record_worldpay_missed_payment, WasteCarriersEngine::RenewingRegistration)
    should_not be_able_to(:refresh_company_name, WasteCarriersEngine::Registration)
    should_not be_able_to(:refund, WasteCarriersEngine::Registration)
    should_not be_able_to(:renew, WasteCarriersEngine::Registration)
    should_not be_able_to(:renew, WasteCarriersEngine::RenewingRegistration)
    should_not be_able_to(:resend_confirmation_email, WasteCarriersEngine::Registration)
    should_not be_able_to(:revert_to_payment_summary, WasteCarriersEngine::RenewingRegistration)
    should_not be_able_to(:reverse, build(:payment, :cash))
    should_not be_able_to(:review_convictions, WasteCarriersEngine::RenewingRegistration)
    should_not be_able_to(:revoke, WasteCarriersEngine::Registration)
    should_not be_able_to(:transfer_registration, WasteCarriersEngine::Registration)
    should_not be_able_to(:update, WasteCarriersEngine::RenewingRegistration)
    should_not be_able_to(:write_off_large, WasteCarriersEngine::FinanceDetails)
    should_not be_able_to(:write_off_large, WasteCarriersEngine::FinanceDetails)
    should_not be_able_to(:write_off_small, build(:finance_details))
  end
end
