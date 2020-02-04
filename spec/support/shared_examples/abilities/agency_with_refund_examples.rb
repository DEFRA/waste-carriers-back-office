# frozen_string_literal: true

RSpec.shared_examples "agency_with_refund examples" do
  it "should be able to view revoked reasons" do
    should be_able_to(:view_revoked_reasons, WasteCarriersEngine::RenewingRegistration)
  end

  it "should be able to refund a payment" do
    should be_able_to(:refund, WasteCarriersEngine::Registration)
  end

  it "should be able to cease a registration" do
    should be_able_to(:cease, WasteCarriersEngine::Registration)
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

      it "should be able to write off" do
        should be_able_to(:write_off_small, finance_details)
      end
    end
  end

  it "should be able to revoke a registration" do
    should be_able_to(:revoke, WasteCarriersEngine::Registration)
  end
end
