# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewabilityCheckService do
  let(:transient_registration) do
    create(:transient_registration, :ready_to_renew)
  end

  let(:registration) do
    WasteCarriersEngine::Registration.where(reg_identifier: transient_registration.reg_identifier).first
  end

  let(:renewability_check_service) do
    RenewabilityCheckService.new(transient_registration)
  end

  describe "#renewal_ready_to_complete?" do
    let(:result) { renewability_check_service.renewal_ready_to_complete? }

    context "when all conditions to renew are met" do
      it "returns true" do
        expect(result).to eq(true)
      end
    end

    context "when the renewal has not been submitted yet" do
      before do
        transient_registration.workflow_state = "business_type_form"
      end

      it "returns false" do
        expect(result).to eq(false)
      end
    end

    context "when the renewal has an unpaid balance" do
      before do
        transient_registration.finance_details.balance = 100
      end

      it "returns false" do
        expect(result).to eq(false)
      end
    end

    context "when the renewal has a pending conviction sign off" do
      before do
        transient_registration.conviction_sign_offs = [build(:conviction_sign_off)]
      end

      it "returns false" do
        expect(result).to eq(false)
      end
    end

    context "when the renewal status is revoked" do
      before do
        transient_registration.metaData.status = :REVOKED
      end

      it "returns false" do
        expect(result).to eq(false)
      end
    end
  end

  describe "#complete_renewal" do
    context "when all conditions to renew are met" do
      it "updates the original registration" do
        updated_renewal_date = registration.expires_on + 3.years

        renewability_check_service.complete_renewal
        expect(registration.reload.expires_on).to eq(updated_renewal_date)
      end
    end

    context "when conditions to renew are not met" do
      before do
        allow(renewability_check_service).to receive(:renewal_ready_to_complete?).and_return(false)
      end

      it "does not update the original registration" do
        old_renewal_date = registration.expires_on

        renewability_check_service.complete_renewal
        expect(registration.reload.expires_on).to eq(old_renewal_date)
      end
    end
  end
end
