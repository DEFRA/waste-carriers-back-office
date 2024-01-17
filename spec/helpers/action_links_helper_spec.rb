# frozen_string_literal: true

require "rails_helper"

RSpec.describe ActionLinksHelper do
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
          expect(helper.display_write_off_small_link_for?(resource)).to be(false)
        end
      end

      context "when the balance is different from 0" do
        let(:balance) { 4 }

        it "returns true" do
          expect(helper.display_write_off_small_link_for?(resource)).to be(true)
        end
      end
    end

    context "when the user does not have permissions to write off small" do
      let(:can) { false }

      it "returns false" do
        expect(helper.display_write_off_small_link_for?(resource)).to be(false)
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
          expect(helper.display_write_off_large_link_for?(resource)).to be(false)
        end
      end

      context "when the balance is different from 0" do
        let(:balance) { 4 }

        it "returns true" do
          expect(helper.display_write_off_large_link_for?(resource)).to be(true)
        end
      end
    end

    context "when the user does not have permissions to write off large" do
      let(:can) { false }

      it "returns false" do
        expect(helper.display_write_off_large_link_for?(resource)).to be(false)
      end
    end
  end

  describe "resume_link_for" do

    shared_examples "metaData.route updates" do
      context "when the registration was started in the back office" do
        it "does not change metaData.route" do
          expect { helper.resume_link_for(resource) }.not_to change { resource.metaData.route }
        end
      end

      context "when the registration was started in the front office with a nil route" do
        before { resource.metaData.route = nil }

        it "changes the assistance mode to partial", :tag do
          expect { helper.resume_link_for(resource) }.to change { resource.metaData.route }.to("PARTIALLY_ASSISTED_DIGITAL")
        end
      end

      context "when the registration was started in the front office with route = DIGITAL" do
        before { resource.metaData.route = "DIGITAL" }

        it "changes the assistance mode to partial" do
          expect { helper.resume_link_for(resource) }.to change { resource.metaData.route }.to("PARTIALLY_ASSISTED_DIGITAL")
        end
      end
    end

    context "when the resource is a new_registration" do
      let(:resource) { build(:new_registration) }

      it "returns the correct path" do
        expect(helper.resume_link_for(resource)).to eq(ad_privacy_policy_path(token: resource.token))
      end

      it_behaves_like "metaData.route updates"
    end

    context "when the resource is a renewing_registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns the correct path" do
        expect(helper.resume_link_for(resource)).to eq(ad_privacy_policy_path(reg_identifier: resource.reg_identifier))
      end

      it_behaves_like "metaData.route updates"
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

  describe "#renewal_magic_link_for" do
    context "when the resource is a new registration" do
      let(:resource) { build(:new_registration, token: "foo") }

      it "returns an nil" do
        expect(helper.renewal_magic_link_for(resource)).to be_nil
      end
    end

    context "when the resource is a renewing registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns nil" do
        expect(helper.renewal_magic_link_for(resource)).to be_nil
      end
    end

    context "when the resource is a registration" do
      context "with a renewal_token" do
        let(:resource) { build(:registration, renew_token: renew_token) }
        let(:renew_token) { "footoken" }

        it "returns the registration path" do
          expect(helper.renewal_magic_link_for(resource))
            .to eq("#{Rails.configuration.wcrs_fo_link_domain}/fo/renew/#{renew_token}")
        end
      end

      context "when the resource doesn't have a renewal token" do
        let(:resource) { build(:registration) }

        it "returns nil" do
          expect(helper.renewal_magic_link_for(resource)).to be_nil
        end
      end
    end
  end

  describe "#display_refund_link_for?" do
    let(:resource) { build(:finance_details, balance: balance) }

    shared_examples "returns true" do
      it { expect(helper.display_refund_link_for?(resource)).to be(true) }
    end

    shared_examples "returns false" do
      it { expect(helper.display_refund_link_for?(resource)).to be(false) }
    end

    context "when the resource has a positive balance" do
      let(:balance) { 5 }

      it_behaves_like "returns false"
    end

    context "when the resource has a balance of 0" do
      let(:balance) { 0 }

      it_behaves_like "returns false"
    end

    context "when the resource has a negative balance" do
      let(:resource) { build(:finance_details, :has_overpaid_order_and_payment) }

      context "when the user does not have the permissions to refund" do
        before { allow(helper).to receive(:can?).with(:refund, resource).and_return(false) }

        it_behaves_like "returns false"
      end

      context "when the user has the permissions to refund" do
        before { allow(helper).to receive(:can?).with(:refund, resource).and_return(true) }

        context "with a worldpay payment" do
          let(:resource) { build(:finance_details, :has_overpaid_order_and_payment) }

          it_behaves_like "returns false"
        end

        context "with a govpay payment" do
          let(:resource) { build(:finance_details, :has_overpaid_order_and_payment_govpay) }

          it_behaves_like "returns true"
        end

        context "with a govpay payment and a pending govpay refund" do
          let(:resource) { build(:finance_details, :has_overpaid_order_and_payment_govpay) }
          let(:refund) { build(:payment, :govpay_refund_pending) }

          before { resource.payments << refund }

          it_behaves_like "returns false"
        end
      end
    end
  end

  describe "#display_check_refund_status_link_for?" do
    let(:resource) { build(:finance_details) }

    context "when there is a refund but it is not pending" do
      before do
        resource.payments << build(:payment, :govpay_refund_complete)
        allow(helper).to receive(:can?).with(:refund, resource).and_return(true)
      end

      it "returns nil" do
        expect(helper.display_check_refund_status_link_for?(resource)).to be_nil
      end
    end

    context "when there is a pending refund" do
      let(:refund) { build(:payment, :govpay_refund_pending) }

      before { resource.payments << refund }

      context "when the user does not have permission to refund" do
        before { allow(helper).to receive(:can?).with(:refund, resource).and_return(false) }

        it "returns false" do
          expect(helper.display_check_refund_status_link_for?(resource)).to be false
        end
      end

      context "when the user has permission to refund" do
        before { allow(helper).to receive(:can?).with(:refund, resource).and_return(true) }

        it "returns true" do
          expect(helper.display_check_refund_status_link_for?(resource)).to eq refund.govpay_id
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
          expect(helper.display_resume_link_for?(resource)).to be(false)
        end
      end

      context "when the user has permission" do
        before { allow(helper).to receive(:can?).with(:create, WasteCarriersEngine::Registration).and_return(true) }

        it "returns true" do
          expect(helper.display_resume_link_for?(resource)).to be(true)
        end
      end
    end

    context "when the resource is a RenewingRegistration" do
      let(:resource) { build(:renewing_registration) }

      context "when the resource has been revoked" do
        before { resource.metaData.status = "REVOKED" }

        it "returns false" do
          expect(helper.display_resume_link_for?(resource)).to be(false)
        end
      end

      context "when the resource has been submitted" do
        before { resource.workflow_state = "renewal_received_pending_payment_form" }

        it "returns false" do
          expect(helper.display_resume_link_for?(resource)).to be(false)
        end
      end

      context "when the resource is in a resumable state" do
        before { resource.workflow_state = "location_form" }

        context "when the user does not have permission" do
          before { allow(helper).to receive(:can?).with(:renew, resource).and_return(false) }

          it "returns false" do
            expect(helper.display_resume_link_for?(resource)).to be(false)
          end
        end

        context "when the user has permission" do
          before { allow(helper).to receive(:can?).with(:renew, resource).and_return(true) }

          it "returns true" do
            expect(helper.display_resume_link_for?(resource)).to be(true)
          end
        end
      end
    end

    context "when the resource is not a NewRegistration or a RenewingRegistration" do
      let(:resource) { build(:registration) }

      it "returns false" do
        expect(helper.display_resume_link_for?(resource)).to be(false)
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
            expect(helper.display_payment_link_for?(resource)).to be(true)
          end
        end

        context "when the resource is not an upper tier" do
          let(:upper_tier) { false }

          it "returns false" do
            expect(helper.display_payment_link_for?(resource)).to be(false)
          end
        end
      end

      context "when the resource is not yet submitted" do
        let(:resource) { build(:renewing_registration) }

        it "returns false" do
          expect(helper.display_payment_link_for?(resource)).to be(false)
        end
      end
    end

    context "when the resource is not a renewing registration" do
      context "when the resource is an upper tier" do
        it "returns true" do
          expect(helper.display_payment_link_for?(resource)).to be(true)
        end
      end

      context "when the resource is not an upper tier" do
        let(:upper_tier) { false }

        it "returns false" do
          expect(helper.display_payment_link_for?(resource)).to be(false)
        end
      end
    end
  end

  describe "#display_cease_or_revoke_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { build(:registration) }

      before do
        allow(helper).to receive(:can?).with(:revoke, WasteCarriersEngine::Registration).and_return(can)
        allow(helper).to receive(:can?).with(:cease, WasteCarriersEngine::Registration).and_return(can)
      end

      context "when the user has permission for revoking" do
        let(:can) { true }

        before do
          allow(resource).to receive(:active?).and_return(active)
        end

        context "when the resource is active" do
          let(:active) { true }

          it "returns true" do
            expect(helper.display_cease_or_revoke_link_for?(resource)).to be(true)
          end
        end

        context "when the resource is not active" do
          let(:active) { false }

          it "returns false" do
            expect(helper.display_cease_or_revoke_link_for?(resource)).to be(false)
          end
        end
      end

      context "when the user has no permission for revoking" do
        let(:can) { false }

        it "returns false" do
          expect(helper.display_cease_or_revoke_link_for?(resource)).to be(false)
        end
      end
    end

    context "when the resource is a transient registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns false" do
        expect(helper.display_cease_or_revoke_link_for?(resource)).to be(false)
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
          allow(resource).to receive(:pending?).and_return(pending)
        end

        context "when the resource is pending" do
          let(:pending) { true }

          it "returns true" do
            expect(helper.display_cancel_link_for?(resource)).to be(true)
          end
        end

        context "when the resource is not pending" do
          let(:pending) { false }

          it "returns false" do
            expect(helper.display_cancel_link_for?(resource)).to be(false)
          end
        end
      end

      context "when the user has no permission for cancelling" do
        let(:can) { false }

        it "returns false" do
          expect(helper.display_cancel_link_for?(resource)).to be(false)
        end
      end
    end

    context "when the resource is a transient registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns false" do
        expect(helper.display_cancel_link_for?(resource)).to be(false)
      end
    end
  end

  describe "#display_edit_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { build(:registration) }

      before do
        allow(helper).to receive(:can?).with(:edit, WasteCarriersEngine::Registration).and_return(can)
      end

      context "when the user has permission for editing" do
        let(:can) { true }

        before do
          allow(resource).to receive(:active?).and_return(active)
        end

        context "when the resource is active" do
          let(:active) { true }

          it "returns true" do
            expect(helper.display_edit_link_for?(resource)).to be(true)
          end
        end

        context "when the resource is not active" do
          let(:active) { false }

          it "returns false" do
            expect(helper.display_edit_link_for?(resource)).to be(false)
          end
        end
      end
    end

    context "when the resource is a transient registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns false" do
        expect(helper.display_edit_link_for?(resource)).to be(false)
      end
    end
  end

  describe "#display_certificate_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { build(:registration) }

      before do
        allow(helper).to receive(:can?).with(:view_certificate, WasteCarriersEngine::Registration).and_return(can)
      end

      context "when the user has permission to view the certificate" do
        let(:can) { true }

        before do
          allow(resource).to receive(:active?).and_return(active)
        end

        context "when the resource is active" do
          let(:active) { true }

          it "returns true" do
            expect(helper.display_certificate_link_for?(resource)).to be(true)
          end
        end

        context "when the resource is not active" do
          let(:active) { false }

          it "returns false" do
            expect(helper.display_certificate_link_for?(resource)).to be(false)
          end
        end
      end

      context "when the user has no permission to view the certificate" do
        let(:can) { false }

        it "returns false" do
          expect(helper.display_certificate_link_for?(resource)).to be(false)
        end
      end
    end

    context "when the resource is a transient registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns false" do
        expect(helper.display_certificate_link_for?(resource)).to be(false)
      end
    end
  end

  describe "#display_resend_confirmation_email_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { build(:registration) }

      before do
        allow(helper)
          .to receive(:can?)
          .with(:resend_confirmation_email, WasteCarriersEngine::Registration)
          .and_return(can)
      end

      context "when the user has permission to resend the confirmation email" do
        let(:can) { true }

        before do
          allow(resource).to receive(:active?).and_return(active)
        end

        context "when the resource is active" do
          let(:active) { true }

          it "returns true" do
            expect(helper.display_resend_confirmation_email_link_for?(resource)).to be(true)
          end
        end

        context "when the resource is not active" do
          let(:active) { false }

          it "returns false" do
            expect(helper.display_resend_confirmation_email_link_for?(resource)).to be(false)
          end
        end
      end

      context "when the user has no permission to resend the confirmation email" do
        let(:can) { false }

        it "returns false" do
          expect(helper.display_resend_confirmation_email_link_for?(resource)).to be(false)
        end
      end
    end

    context "when the resource is a transient registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns false" do
        expect(helper.display_certificate_link_for?(resource)).to be(false)
      end
    end
  end

  describe "#display_order_copy_cards_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { build(:registration) }

      before do
        allow(helper).to receive(:can?).with(:order_copy_cards, WasteCarriersEngine::Registration).and_return(can)
      end

      context "when the user has permission for ordering copy cards" do
        let(:can) { true }

        before do
          allow(resource).to receive(:active?).and_return(active)
        end

        context "when the resource is active" do
          let(:active) { true }

          before do
            allow(resource).to receive(:upper_tier?).and_return(upper_tier)
          end

          context "when the resource is an upper tier" do
            let(:upper_tier) { true }

            it "returns true" do
              expect(helper.display_order_copy_cards_link_for?(resource)).to be(true)
            end
          end

          context "when the resource is not an upper tier" do
            let(:upper_tier) { false }

            it "returns false" do
              expect(helper.display_order_copy_cards_link_for?(resource)).to be(false)
            end
          end
        end

        context "when the resource is not active" do
          let(:active) { false }

          it "returns false" do
            expect(helper.display_order_copy_cards_link_for?(resource)).to be(false)
          end
        end
      end

      context "when the user has no permission for ordering copy cards" do
        let(:can) { false }

        it "returns false" do
          expect(helper.display_order_copy_cards_link_for?(resource)).to be(false)
        end
      end
    end

    context "when the resource is a transient registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns false" do
        expect(helper.display_order_copy_cards_link_for?(resource)).to be(false)
      end
    end
  end

  describe "#display_refresh_registered_company_name_link_for?" do
    let(:resource) { build(:registration) }

    before do
      allow(helper).to receive(:can?).with(:edit, WasteCarriersEngine::Registration).and_return(can)
    end

    context "when the user has permission for editing" do
      let(:can) { true }

      before do
        allow(resource).to receive(:active?).and_return(active)
      end

      context "when the resource is active" do
        let(:active) { true }

        before do
          allow(resource).to receive(:upper_tier?).and_return(upper_tier)
        end

        context "when the resource is an upper tier" do
          let(:upper_tier) { true }

          context "when the resource is a limited company or a limited liability partnership" do
            before do
              allow(resource).to receive(:company_no_required?).and_return(true)
            end

            it "returns true" do
              expect(helper.display_refresh_registered_company_name_link_for?(resource)).to be(true)
            end
          end

          context "when the resource is neither a limited company nor a limited liability partnership" do
            before do
              allow(resource).to receive(:company_no_required?).and_return(false)
            end

            it "returns false" do
              expect(helper.display_refresh_registered_company_name_link_for?(resource)).to be(false)
            end
          end
        end

        context "when the resource is not an upper tier" do
          let(:upper_tier) { false }

          it "returns false" do
            expect(helper.display_refresh_registered_company_name_link_for?(resource)).to be(false)
          end
        end
      end

      context "when the resource is not active" do
        let(:active) { false }

        it "returns false" do
          expect(helper.display_refresh_registered_company_name_link_for?(resource)).to be(false)
        end
      end
    end

    context "when the user does not have permission for editing" do
      let(:can) { false }

      it "returns false" do
        expect(helper.display_refresh_registered_company_name_link_for?(resource)).to be(false)
      end
    end
  end

  describe "#display_restart_renewal_link_for?" do
    let(:resource) { build(:registration) }

    before do
      allow(helper).to receive(:can?).with(:edit, WasteCarriersEngine::Registration).and_return(can)
    end

    context "when the user has permission for editing" do
      let(:can) { true }

      context "when the resource is a registration" do
        it "returns false" do
          expect(helper.display_restart_renewal_link_for?(resource)).to be(false)
        end
      end

      context "when a renewal is in progress" do
        let(:renewing_registration) { create(:renewing_registration) }

        it "returns true" do
          expect(helper.display_restart_renewal_link_for?(renewing_registration)).to be(true)
        end
      end
    end

    context "when the user does not have permission for editing" do
      let(:renewing_registration) { create(:renewing_registration) }
      let(:can) { false }

      it "returns false" do
        expect(helper.display_refresh_registered_company_name_link_for?(renewing_registration)).to be(false)
      end
    end
  end

  describe "#display_finance_details_link_for?" do
    let(:resource) { double(:resource) }
    let(:upper_tier) { true }
    let(:finance_details) { double(:finance_details) }

    before do
      allow(resource).to receive_messages(upper_tier?: upper_tier, finance_details: finance_details)
    end

    context "when the resource is a new registration" do
      let(:resource) { build(:new_registration) }

      it "returns false" do
        expect(helper.display_finance_details_link_for?(resource)).to be(false)
      end
    end

    context "when the resource is a renewing registration" do
      context "when the resource is submitted" do
        let(:resource) { build(:renewing_registration, :submitted) }

        context "when the resource is an upper tier" do
          it "returns true" do
            expect(helper.display_finance_details_link_for?(resource)).to be(true)
          end
        end

        context "when the resource is not an upper tier" do
          let(:upper_tier) { false }

          it "returns false" do
            expect(helper.display_finance_details_link_for?(resource)).to be(false)
          end
        end
      end

      context "when the resource is not yet submitted" do
        let(:resource) { build(:renewing_registration) }

        it "returns false" do
          expect(helper.display_finance_details_link_for?(resource)).to be(false)
        end
      end
    end

    context "when the resource is not a renewing registration" do
      context "when the resource is an upper tier" do
        context "when the resource has finance details" do
          it "returns true" do
            expect(helper.display_finance_details_link_for?(resource)).to be(true)
          end
        end

        context "when the resource has no finance details" do
          let(:finance_details) { nil }

          it "returns false" do
            expect(helper.display_finance_details_link_for?(resource)).to be(false)
          end
        end
      end

      context "when the resource is not an upper tier" do
        let(:upper_tier) { false }

        it "returns false" do
          expect(helper.display_finance_details_link_for?(resource)).to be(false)
        end
      end
    end
  end

  describe "#display_refresh_ea_area_link_for?" do
    context "when address is present" do
      let(:company_address) { build(:address, :registered) }
      let(:resource) { build(:registration, company_address: company_address) }

      it "returns true" do
        expect(helper.display_refresh_ea_area_link_for?(resource)).to be(true)
      end
    end

    context "when address is blank" do
      let(:resource) { build(:registration, company_address: nil) }

      it "returns false" do
        expect(helper.display_refresh_ea_area_link_for?(resource)).to be(false)
      end
    end

    context "when address postcode is blank" do
      let(:company_address) { build(:address, :registered, postcode: nil) }
      let(:resource) { build(:registration, company_address: company_address) }

      it "returns false" do
        expect(helper.display_refresh_ea_area_link_for?(resource)).to be(false)
      end
    end

    context "when the resource is a transient registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns false" do
        expect(helper.display_refresh_ea_area_link_for?(resource)).to be(false)
      end
    end
  end

  describe "#display_communication_records_link_for?" do
    context "when resource is not a Registration" do
      let(:invalid_resource) { build(:address) }

      it "returns false" do
        expect(helper.display_communication_records_link_for?(invalid_resource)).to be(false)
      end
    end

    context "when user has no permissions to view communication history" do
      let(:resource) { build(:registration) }

      before { allow(helper).to receive(:can?).and_return(false) }

      it "returns false" do
        expect(helper.display_communication_records_link_for?(resource)).to be(false)
      end
    end

    context "when resourse is a Registration and user has permissions to view communication history" do
      let(:resource) { build(:registration) }

      before { allow(helper).to receive(:can?).and_return(true) }

      it "returns true" do
        expect(helper.display_communication_records_link_for?(resource)).to be(true)
      end
    end
  end

  describe "#display_renew_link_for?" do
    context "when the resource is not a Registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns false" do
        expect(helper.display_renew_link_for?(resource)).to be(false)
      end
    end

    context "when the resource is a Registration" do
      let(:resource) { build(:registration) }

      context "when the user does not have permission" do
        before { allow(helper).to receive(:can?).and_return(false) }

        it "returns false" do
          expect(helper.display_renew_link_for?(resource)).to be(false)
        end
      end

      context "when the user has permission" do
        before { allow(helper).to receive(:can?).and_return(true) }

        context "when the resource cannot begin a renewal" do
          before { allow(resource).to receive(:can_start_renewal?).and_return(false) }

          it "returns false" do
            expect(helper.display_renew_link_for?(resource)).to be(false)
          end
        end

        context "when the resource can begin a renewal" do
          before { allow(resource).to receive(:can_start_renewal?).and_return(true) }

          it "returns true" do
            expect(helper.display_renew_link_for?(resource)).to be(true)
          end
        end
      end
    end
  end

  describe "#display_restore_registration_link_for?" do

    subject(:display_link) { helper.display_restore_registration_link_for?(resource) }

    before { allow(helper).to receive(:can?).with(:restore, WasteCarriersEngine::Registration).and_return(true) }

    context "when the resource is not a Registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns false" do
        expect(display_link).to be(false)
      end
    end

    context "when the resource is a Registration" do
      let(:resource) { build(:registration) }

      context "when the resource is not revoked or ceased" do
        before { resource.metaData.status = %w[ACTIVE EXPIRED REFUSED PENDING].sample }

        it "returns false" do
          expect(display_link).to be(false)
        end
      end

      context "when the resource has been revoked or ceased" do
        before { resource.metaData.status = %w[REVOKED INACTIVE].sample }

        context "when the user does not have permission" do
          before { allow(helper).to receive(:can?).with(:restore, WasteCarriersEngine::Registration).and_return(false) }

          it "returns false" do
            expect(display_link).to be(false)
          end
        end

        context "when the user has permission" do
          before { allow(helper).to receive(:can?).with(:restore, WasteCarriersEngine::Registration).and_return(true) }

          context "when the registration has an expiry date in the past" do
            before { resource.expires_on = 2.days.ago }

            it "returns false" do
              expect(display_link).to be(false)
            end
          end

          context "when the registration has an expiry date not in the past" do
            before { resource.expires_on = 1.day.from_now }

            it "returns true" do
              expect(display_link).to be(true)
            end
          end
        end
      end
    end
  end

  describe "#display_ways_to_share_magic_link_for?" do
    let(:resource) { build(:registration) }

    context "when the 'renewal_reminders' feature toggle is not enabled" do
      before do
        allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:renewal_reminders).and_return(false)
      end

      it "returns false" do
        expect(helper.display_ways_to_share_magic_link_for?(resource)).to be(false)
      end
    end

    context "when the 'renewal_reminders' feature toggle is enabled" do
      before do
        allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:renewal_reminders).and_return(true)
      end

      context "when the resource the resource is not a Registration" do
        let(:resource) { build(:renewing_registration) }

        it "returns false" do
          expect(helper.display_ways_to_share_magic_link_for?(resource)).to be(false)
        end
      end

      context "when the user does not have permission" do
        before { allow(helper).to receive(:can?).with(:renew, WasteCarriersEngine::Registration).and_return(false) }

        it "returns false" do
          expect(helper.display_ways_to_share_magic_link_for?(resource)).to be(false)
        end
      end

      context "when the user has permission" do
        before { allow(helper).to receive(:can?).with(:renew, WasteCarriersEngine::Registration).and_return(true) }

        context "when the resource cannot begin a renewal in the front office" do
          before { allow(resource).to receive(:can_start_front_office_renewal?).and_return(false) }

          it "returns false" do
            expect(helper.display_ways_to_share_magic_link_for?(resource)).to be(false)
          end
        end

        context "when the resource can begin a renewal in the front office" do
          before { allow(resource).to receive(:can_start_front_office_renewal?).and_return(true) }

          it "returns true" do
            expect(helper.display_ways_to_share_magic_link_for?(resource)).to be(true)
          end
        end
      end
    end
  end
end
