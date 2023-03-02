# frozen_string_literal: true

RSpec.shared_examples "data_agent examples" do

  it "is able to view the certificate" do
    expect(subject).to be_able_to(:view_certificate, WasteCarriersEngine::Registration)
  end

  it "is able to view revoked reasons" do
    expect(subject).to be_able_to(:view_revoked_reasons, WasteCarriersEngine::RenewingRegistration)
  end

  it "is not able to do anything else" do
    expect(subject).not_to be_able_to(:cancel, WasteCarriersEngine::Registration)
    expect(subject).not_to be_able_to(:cease, WasteCarriersEngine::Registration)
    expect(subject).not_to be_able_to(:charge_adjust, WasteCarriersEngine::Registration)
    expect(subject).not_to be_able_to(:charge_adjust, WasteCarriersEngine::RenewingRegistration)
    expect(subject).not_to be_able_to(:create, WasteCarriersEngine::Registration)
    expect(subject).not_to be_able_to(:edit, WasteCarriersEngine::Registration)
    expect(subject).not_to be_able_to(:import_conviction_data, :all)
    expect(subject).not_to be_able_to(:manage, WasteCarriersEngine::FeatureToggle)
    expect(subject).not_to be_able_to(:manage_back_office_users, User)
    expect(subject).not_to be_able_to(:modify_user, user)
    expect(subject).not_to be_able_to(:record_bank_transfer_payment, WasteCarriersEngine::RenewingRegistration)
    expect(subject).not_to be_able_to(:record_cash_payment, WasteCarriersEngine::RenewingRegistration)
    expect(subject).not_to be_able_to(:record_cheque_payment, WasteCarriersEngine::RenewingRegistration)
    expect(subject).not_to be_able_to(:record_postal_order_payment, WasteCarriersEngine::RenewingRegistration)
    expect(subject).not_to be_able_to(:refresh_company_name, WasteCarriersEngine::Registration)
    expect(subject).not_to be_able_to(:refund, WasteCarriersEngine::Registration)
    expect(subject).not_to be_able_to(:renew, WasteCarriersEngine::Registration)
    expect(subject).not_to be_able_to(:renew, WasteCarriersEngine::RenewingRegistration)
    expect(subject).not_to be_able_to(:resend_confirmation_email, WasteCarriersEngine::Registration)
    expect(subject).not_to be_able_to(:revert_to_payment_summary, WasteCarriersEngine::RenewingRegistration)
    expect(subject).not_to be_able_to(:reverse, build(:payment, :cash))
    expect(subject).not_to be_able_to(:review_convictions, WasteCarriersEngine::RenewingRegistration)
    expect(subject).not_to be_able_to(:revoke, WasteCarriersEngine::Registration)
    expect(subject).not_to be_able_to(:run_finance_reports, :all)
    expect(subject).not_to be_able_to(:transfer_registration, WasteCarriersEngine::Registration)
    expect(subject).not_to be_able_to(:update, WasteCarriersEngine::RenewingRegistration)
    expect(subject).not_to be_able_to(:write_off_large, WasteCarriersEngine::FinanceDetails)
    expect(subject).not_to be_able_to(:write_off_large, WasteCarriersEngine::FinanceDetails)
    expect(subject).not_to be_able_to(:write_off_small, build(:finance_details))
  end
end
