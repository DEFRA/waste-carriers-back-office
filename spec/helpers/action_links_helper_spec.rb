# frozen_string_literal: true

require "rails_helper"

RSpec.describe ActionLinksHelper, type: :helper do
  describe "details_link_for" do
    context "when the resource is a new registration" do
      let(:resource) { build(:new_registration, token: "foo") }

      it "returns the new registration path" do
        expect(helper.details_link_for(resource)).to eq(new_registration_path(resource.token))
      end
    end

    context "when the resource is a renewing registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns the renewing registration path" do
        expect(helper.details_link_for(resource)).to eq(renewing_registration_path(resource.reg_identifier))
      end
    end

    context "when the resource is a registration" do
      let(:resource) { build(:registration, reg_identifier: "CBDU1") }

      it "returns the registration path" do
        expect(helper.details_link_for(resource)).to eq(registration_path(resource.reg_identifier))
      end
    end
  end

  describe "#display_write_off_small_link_for?" do
    let(:balance) { 0 }
    let(:resource) { double(:resource, balance: balance) }

    before do
      allow(helper).to receive(:can?).with(:write_off_small, resource).and_return(can)
    end

    context "when the user has permission to write off small" do
      let(:can) { true }

      context "when the balance is equal to 0" do
        it "returns false" do
          expect(helper.display_write_off_small_link_for?(resource)).to be_falsey
        end
      end

      context "when the balance is different from 0" do
        let(:balance) { 4 }

        it "returns true" do
          expect(helper.display_write_off_small_link_for?(resource)).to be_truthy
        end
      end
    end

    context "when the user does not have permissions to write off small" do
      let(:can) { false }

      it "returns false" do
        expect(helper.display_write_off_small_link_for?(resource)).to be_falsey
      end
    end
  end

  describe "#display_write_off_large_link_for?" do
    let(:balance) { 0 }
    let(:resource) { double(:resource, balance: balance) }

    before do
      allow(helper).to receive(:can?).with(:write_off_large, resource).and_return(can)
    end

    context "when the user has permission to write off large" do
      let(:can) { true }

      context "when the balance is equal to 0" do
        it "returns false" do
          expect(helper.display_write_off_large_link_for?(resource)).to be_falsey
        end
      end

      context "when the balance is different from 0" do
        let(:balance) { 4 }

        it "returns true" do
          expect(helper.display_write_off_large_link_for?(resource)).to be_truthy
        end
      end
    end

    context "when the user does not have permissions to write off large" do
      let(:can) { false }

      it "returns false" do
        expect(helper.display_write_off_large_link_for?(resource)).to be_falsey
      end
    end
  end

  describe "resume_link_for" do
    context "when the resource is a new_registration" do
      let(:resource) { build(:new_registration) }

      it "returns the correct path" do
        expect(helper.resume_link_for(resource)).to eq(ad_privacy_policy_path(token: resource.token))
      end
    end

    context "when the resource is a renewing_registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns the correct path" do
        expect(helper.resume_link_for(resource)).to eq(ad_privacy_policy_path(reg_identifier: resource.reg_identifier))
      end
    end
  end

  describe "renew_link_for" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      it "returns the correct path" do
        expect(helper.renew_link_for(resource)).to eq(ad_privacy_policy_path(reg_identifier: resource.reg_identifier))
      end
    end
  end

  describe "#display_renewal_link_for?" do
    let(:resource) { build(:registration) }

    context "when the 'renewal_reminders' feature toggle is enabled" do
      before do
        allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:renewal_reminders).and_return(true)
      end

      context "but the resource is not a Registration" do
        let(:resource) { build(:renewing_registration) }

        it "returns false" do
          expect(helper.display_renewal_link_for?(resource)).to eq(false)
        end
      end

      context "and the user does not have permission" do
        before { allow(helper).to receive(:can?).and_return(false) }

        it "returns false" do
          expect(helper.display_renewal_link_for?(resource)).to eq(false)
        end
      end

      context "and the user has permission" do
        before { allow(helper).to receive(:can?).and_return(true) }

        context "and the resource cannot begin a renewal" do
          before { allow(resource).to receive(:can_start_renewal?).and_return(false) }

          it "returns false" do
            expect(helper.display_renewal_link_for?(resource)).to eq(false)
          end
        end

        context "and the resource can begin a renewal" do
          before { allow(resource).to receive(:can_start_renewal?).and_return(true) }

          it "returns true" do
            expect(helper.display_renewal_link_for?(resource)).to eq(true)
          end
        end
      end
    end

    context "when the 'renewal_reminders' feature toggle is not enabled" do
      before do
        allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:renewal_reminders).and_return(false)
      end

      it "returns false" do
        expect(helper.display_renewal_link_for?(resource)).to eq(false)
      end
    end
  end

  describe "renewal_link_for" do
    context "when the resource is a new registration" do
      let(:resource) { build(:new_registration, token: "foo") }

      it "returns an nil" do
        expect(helper.renewal_link_for(resource)).to be_nil
      end
    end

    context "when the resource is a renewing registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns nil" do
        expect(helper.renewal_link_for(resource)).to be_nil
      end
    end

    context "when the resource is a registration" do
      context "and has a renewal_token" do
        let(:resource) { build(:registration, renew_token: renew_token) }
        let(:renew_token) { "footoken" }

        it "returns the registration path" do
          expect(helper.renewal_link_for(resource))
            .to eq("#{Rails.configuration.wcrs_renewals_url}/fo/renew/#{renew_token}")
        end
      end

      context "but doesn't have a renewal token" do
        let(:resource) { build(:registration) }

        it "returns nil" do
          expect(helper.renewal_link_for(resource)).to be_nil
        end
      end
    end
  end

  describe "#display_refund_link_for?" do
    let(:resource) { build(:finance_details, balance: balance) }

    context "when the resource has a positive balance" do
      let(:balance) { 5 }

      it "returns false" do
        expect(helper.display_refund_link_for?(resource)).to be_falsey
      end
    end

    context "when the resource has a balance of 0" do
      let(:balance) { 0 }

      it "returns false" do
        expect(helper.display_refund_link_for?(resource)).to be_falsey
      end
    end

    context "when the resource has a negative balance" do
      let(:balance) { -20 }

      context "when the user has the permissions to refund" do
        it "returns true" do
          expect(helper).to receive(:can?).with(:refund, resource).and_return(true)

          expect(helper.display_refund_link_for?(resource)).to be_truthy
        end
      end

      context "when the user does not have the permissions to refund" do
        it "returns false" do
          expect(helper).to receive(:can?).with(:refund, resource).and_return(false)

          expect(helper.display_refund_link_for?(resource)).to be_falsey
        end
      end
    end
  end

  describe "#display_resume_link_for?" do
    context "when the resource is a NewRegistration" do
      let(:resource) { build(:new_registration) }

      context "when the user does not have permission" do
        before { allow(helper).to receive(:can?).with(:create, WasteCarriersEngine::Registration).and_return(false) }

        it "returns false" do
          expect(helper.display_resume_link_for?(resource)).to eq(false)
        end
      end

      context "when the user has permission" do
        before { allow(helper).to receive(:can?).with(:create, WasteCarriersEngine::Registration).and_return(true) }

        it "returns true" do
          expect(helper.display_resume_link_for?(resource)).to eq(true)
        end
      end
    end

    context "when the resource is a RenewingRegistration" do
      let(:resource) { build(:renewing_registration) }

      context "when the resource has been revoked" do
        before { resource.metaData.status = "REVOKED" }

        it "returns false" do
          expect(helper.display_resume_link_for?(resource)).to eq(false)
        end
      end

      context "when the resource has been submitted" do
        before { resource.workflow_state = "renewal_received_pending_payment_form" }

        it "returns false" do
          expect(helper.display_resume_link_for?(resource)).to eq(false)
        end
      end

      context "when the resource is in WorldPay" do
        before { resource.workflow_state = "worldpay_form" }

        it "returns false" do
          expect(helper.display_resume_link_for?(resource)).to eq(false)
        end
      end

      context "when the resource is in a resumable state" do
        before { resource.workflow_state = "location_form" }

        context "when the user does not have permission" do
          before { allow(helper).to receive(:can?).with(:renew, resource).and_return(false) }

          it "returns false" do
            expect(helper.display_resume_link_for?(resource)).to eq(false)
          end
        end

        context "when the user has permission" do
          before { allow(helper).to receive(:can?).with(:renew, resource).and_return(true) }

          it "returns true" do
            expect(helper.display_resume_link_for?(resource)).to eq(true)
          end
        end
      end
    end

    context "when the resource is not a NewRegistration or a RenewingRegistration" do
      let(:resource) { build(:registration) }

      it "returns false" do
        expect(helper.display_resume_link_for?(resource)).to eq(false)
      end
    end
  end

  describe "#display_payment_link_for?" do
    let(:resource) { double(:resource) }
    let(:upper_tier) { true }

    before do
      allow(resource).to receive(:upper_tier?).and_return(upper_tier)
      allow(helper).to receive(:can?).with(:view_payments, resource).and_return(true)
    end

    context "when the resource is a renewing registration" do
      context "when the resource is submitted" do
        let(:resource) { build(:renewing_registration, :submitted) }

        context "when the resource is an upper tier" do
          it "returns true" do
            expect(helper.display_payment_link_for?(resource)).to be_truthy
          end
        end

        context "when the resource is not an upper tier" do
          let(:upper_tier) { false }

          it "returns false" do
            expect(helper.display_payment_link_for?(resource)).to be_falsey
          end
        end
      end

      context "when the resource is not yet submitted" do
        let(:resource) { build(:renewing_registration) }

        it "returns false" do
          expect(helper.display_payment_link_for?(resource)).to be_falsey
        end
      end
    end

    context "when the resource is not a renewing registration" do
      context "when the resource is an upper tier" do
        it "returns true" do
          expect(helper.display_payment_link_for?(resource)).to be_truthy
        end
      end

      context "when the resource is not an upper tier" do
        let(:upper_tier) { false }

        it "returns false" do
          expect(helper.display_payment_link_for?(resource)).to be_falsey
        end
      end
    end
  end

  describe "#display_cease_or_revoke_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { build(:registration) }

      before do
        allow(helper).to receive(:can?).with(:revoke, resource).and_return(can)
        allow(helper).to receive(:can?).with(:cease, resource).and_return(can)
      end

      context "when the user has permission for revoking" do
        let(:can) { true }

        before do
          expect(resource).to receive(:active?).and_return(active)
        end

        context "when the resource is active" do
          let(:active) { true }

          it "returns true" do
            expect(helper.display_cease_or_revoke_link_for?(resource)).to be_truthy
          end
        end

        context "when the resource is not active" do
          let(:active) { false }

          it "returns false" do
            expect(helper.display_cease_or_revoke_link_for?(resource)).to be_falsey
          end
        end
      end

      context "when the user has no permission for revoking" do
        let(:can) { false }

        it "returns false" do
          expect(helper.display_cease_or_revoke_link_for?(resource)).to be_falsey
        end
      end
    end

    context "when the resource is a transient registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns false" do
        expect(helper.display_cease_or_revoke_link_for?(resource)).to be_falsey
      end
    end
  end

  describe "#display_cancel_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { build(:registration) }

      before do
        allow(helper).to receive(:can?).with(:cancel, WasteCarriersEngine::Registration).and_return(can)
      end

      context "when the user has permission for cancelling" do
        let(:can) { true }

        before do
          expect(resource).to receive(:pending?).and_return(pending)
        end

        context "when the resource is pending" do
          let(:pending) { true }

          it "returns true" do
            expect(helper.display_cancel_link_for?(resource)).to be_truthy
          end
        end

        context "when the resource is not pending" do
          let(:pending) { false }

          it "returns false" do
            expect(helper.display_cancel_link_for?(resource)).to be_falsey
          end
        end
      end

      context "when the user has no permission for cancelling" do
        let(:can) { false }

        it "returns false" do
          expect(helper.display_cancel_link_for?(resource)).to be_falsey
        end
      end
    end

    context "when the resource is a transient registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns false" do
        expect(helper.display_cancel_link_for?(resource)).to be_falsey
      end
    end
  end

  describe "#display_edit_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { build(:registration) }

      before do
        expect(helper).to receive(:can?).with(:edit, WasteCarriersEngine::Registration).and_return(can)
      end

      context "when the user has permission for editing" do
        let(:can) { true }

        before do
          expect(resource).to receive(:active?).and_return(active)
        end

        context "when the resource is active" do
          let(:active) { true }

          it "returns true" do
            expect(helper.display_edit_link_for?(resource)).to be_truthy
          end
        end

        context "when the resource is not active" do
          let(:active) { false }

          it "returns false" do
            expect(helper.display_edit_link_for?(resource)).to be_falsey
          end
        end
      end
    end

    context "when the resource is a transient registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns false" do
        expect(helper.display_edit_link_for?(resource)).to be_falsey
      end
    end
  end

  describe "#display_certificate_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { build(:registration) }

      before do
        expect(helper).to receive(:can?).with(:view_certificate, WasteCarriersEngine::Registration).and_return(can)
      end

      context "when the user has permission to view the certificate" do
        let(:can) { true }

        before do
          expect(resource).to receive(:active?).and_return(active)
        end

        context "when the resource is active" do
          let(:active) { true }

          it "returns true" do
            expect(helper.display_certificate_link_for?(resource)).to be_truthy
          end
        end

        context "when the resource is not active" do
          let(:active) { false }

          it "returns false" do
            expect(helper.display_certificate_link_for?(resource)).to be_falsey
          end
        end
      end

      context "when the user has no permission to view the certificate" do
        let(:can) { false }

        it "returns false" do
          expect(helper.display_certificate_link_for?(resource)).to be_falsey
        end
      end
    end

    context "when the resource is a transient registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns false" do
        expect(helper.display_certificate_link_for?(resource)).to be_falsey
      end
    end
  end

  describe "#display_order_copy_cards_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { build(:registration) }

      before do
        expect(helper).to receive(:can?).with(:order_copy_cards, WasteCarriersEngine::Registration).and_return(can)
      end

      context "when the user has permission for ordering copy cards" do
        let(:can) { true }

        before do
          expect(resource).to receive(:active?).and_return(active)
        end

        context "when the resource is active" do
          let(:active) { true }

          before do
            expect(resource).to receive(:upper_tier?).and_return(upper_tier)
          end

          context "when the resource is an upper tier" do
            let(:upper_tier) { true }

            it "returns true" do
              expect(helper.display_order_copy_cards_link_for?(resource)).to be_truthy
            end
          end

          context "when the resource is not an upper tier" do
            let(:upper_tier) { false }

            it "returns false" do
              expect(helper.display_order_copy_cards_link_for?(resource)).to be_falsey
            end
          end
        end

        context "when the resource is not active" do
          let(:active) { false }

          it "returns false" do
            expect(helper.display_order_copy_cards_link_for?(resource)).to be_falsey
          end
        end
      end

      context "when the user has no permission for ordering copy cards" do
        let(:can) { false }

        it "returns false" do
          expect(helper.display_order_copy_cards_link_for?(resource)).to be_falsey
        end
      end
    end

    context "when the resource is a transient registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns false" do
        expect(helper.display_order_copy_cards_link_for?(resource)).to be_falsey
      end
    end
  end

  describe "#display_finance_details_link_for?" do
    let(:resource) { double(:resource) }
    let(:upper_tier) { true }
    let(:finance_details) { double(:finance_details) }

    before do
      allow(resource).to receive(:upper_tier?).and_return(upper_tier)
      allow(resource).to receive(:finance_details).and_return(finance_details)
    end

    context "when the resource is a new registration" do
      let(:resource) { build(:new_registration) }

      it "returns false" do
        expect(helper.display_finance_details_link_for?(resource)).to be_falsey
      end
    end

    context "when the resource is a renewing registration" do
      context "when the resource is submitted" do
        let(:resource) { build(:renewing_registration, :submitted) }

        context "when the resource is an upper tier" do
          it "returns true" do
            expect(helper.display_finance_details_link_for?(resource)).to be_truthy
          end
        end

        context "when the resource is not an upper tier" do
          let(:upper_tier) { false }

          it "returns false" do
            expect(helper.display_finance_details_link_for?(resource)).to be_falsey
          end
        end
      end

      context "when the resource is not yet submitted" do
        let(:resource) { build(:renewing_registration) }

        it "returns false" do
          expect(helper.display_finance_details_link_for?(resource)).to be_falsey
        end
      end
    end

    context "when the resource is not a renewing registration" do
      context "when the resource is an upper tier" do
        context "when the resource has finance details" do
          it "returns true" do
            expect(helper.display_finance_details_link_for?(resource)).to be_truthy
          end
        end

        context "when the resource has no finance details" do
          let(:finance_details) { nil }

          it "returns false" do
            expect(helper.display_finance_details_link_for?(resource)).to be_falsey
          end
        end
      end

      context "when the resource is not an upper tier" do
        let(:upper_tier) { false }

        it "returns false" do
          expect(helper.display_finance_details_link_for?(resource)).to be_falsey
        end
      end
    end
  end

  describe "#display_renew_link_for?" do
    context "when the resource is not a Registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns false" do
        expect(helper.display_renew_link_for?(resource)).to eq(false)
      end
    end

    context "when the resource is a Registration" do
      let(:resource) { build(:registration) }

      context "when the user does not have permission" do
        before { allow(helper).to receive(:can?).and_return(false) }

        it "returns false" do
          expect(helper.display_renew_link_for?(resource)).to eq(false)
        end
      end

      context "when the user has permission" do
        before { allow(helper).to receive(:can?).and_return(true) }

        context "when the resource cannot begin a renewal" do
          before { allow(resource).to receive(:can_start_renewal?).and_return(false) }

          it "returns false" do
            expect(helper.display_renew_link_for?(resource)).to eq(false)
          end
        end

        context "when the resource can begin a renewal" do
          before { allow(resource).to receive(:can_start_renewal?).and_return(true) }

          it "returns true" do
            expect(helper.display_renew_link_for?(resource)).to eq(true)
          end
        end
      end
    end
  end

  describe "#display_transfer_link_for?" do
    context "when the resource is not a Registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns false" do
        expect(helper.display_transfer_link_for?(resource)).to eq(false)
      end
    end

    context "when the resource is a Registration" do
      let(:resource) { build(:registration) }

      context "when the resource has been revoked or refused" do
        before { resource.metaData.status = %w[REVOKED REFUSED].sample }

        it "returns false" do
          expect(helper.display_transfer_link_for?(resource)).to eq(false)
        end
      end

      context "when the resource is not revoked or refused" do
        before { resource.metaData.status = %w[ACTIVE EXPIRED PENDING].sample }

        context "when the user does not have permission" do
          before { allow(helper).to receive(:can?).with(:transfer_registration, WasteCarriersEngine::Registration).and_return(false) }

          it "returns false" do
            expect(helper.display_transfer_link_for?(resource)).to eq(false)
          end
        end

        context "when the user has permission" do
          before { allow(helper).to receive(:can?).with(:transfer_registration, WasteCarriersEngine::Registration).and_return(true) }

          it "returns true" do
            expect(helper.display_transfer_link_for?(resource)).to eq(true)
          end
        end
      end
    end
  end
end
