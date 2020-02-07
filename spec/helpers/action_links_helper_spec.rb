# frozen_string_literal: true

require "rails_helper"

RSpec.describe ActionLinksHelper, type: :helper do
  describe "details_link_for" do
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

    context "when the resource is not a registration or a renewing registration" do
      let(:resource) { double(:resource) }

      it "returns a default path" do
        expect(helper.details_link_for(resource)).to eq("#")
      end
    end
  end

  describe "#display_write_off_small_link_for?" do
    let(:balance) { 0 }
    let(:resource) { double(:resource, balance: balance) }

    before do
      allow(helper).to receive(:can?).and_return(can)
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
      allow(helper).to receive(:can?).and_return(can)
    end

    context "when the user has permission to write off small" do
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

    context "when the user does not have permissions to write off small" do
      let(:can) { false }

      it "returns false" do
        expect(helper.display_write_off_large_link_for?(resource)).to be_falsey
      end
    end
  end

  describe "resume_link_for" do
    context "when the resource is a transient_registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns the correct path" do
        expect(helper.resume_link_for(resource)).to eq(ad_privacy_policy_path(resource.reg_identifier))
      end
    end

    context "when the resource is not a transient_registration" do
      let(:resource) { build(:registration) }

      it "returns the correct path" do
        expect(helper.resume_link_for(resource)).to eq("#")
      end
    end
  end

  describe "convictions_link_for" do
    context "when the resource is a transient_registration" do
      let(:resource) { build(:renewing_registration) }

      it "returns the correct path" do
        expect(helper.convictions_link_for(resource)).to eq(transient_registration_convictions_path(resource.reg_identifier))
      end
    end

    # TODO: re-implement when internal route exists https://eaflood.atlassian.net/browse/RUBY-786
    # context "when the resource is a registration" do
    #   let(:resource) { build(:registration) }

    #   it "returns the correct path" do
    #     path = "#{Rails.configuration.wcrs_backend_url}/registrations/#{resource.id}/approve"
    #     expect(helper.convictions_link_for(resource)).to eq(path)
    #   end
    # end

    context "when the resource is not a registration or a transient_registration" do
      let(:resource) { nil }

      it "returns the correct path" do
        expect(helper.convictions_link_for(resource)).to eq("#")
      end
    end
  end

  describe "renew_link_for" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      it "returns the correct path" do
        expect(helper.renew_link_for(resource)).to eq(ad_privacy_policy_path(resource.reg_identifier))
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { create(:renewing_registration) }

      it "returns the correct path" do
        expect(helper.renew_link_for(resource)).to eq("#")
      end
    end
  end

  describe "transfer_link_for" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      it "returns the correct path" do
        expect(helper.transfer_link_for(resource)).to eq(new_registration_registration_transfer_path(resource.reg_identifier))
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { create(:renewing_registration) }

      it "returns the correct path" do
        expect(helper.transfer_link_for(resource)).to eq("#")
      end
    end
  end

  describe "#display_details_link_for?" do
    context "when the resource is a Registration" do
      let(:resource) { build(:registration) }

      it "returns true" do
        expect(helper.display_details_link_for?(resource)).to eq(true)
      end
    end

    context "when the resource is not a Registration or a RenewingRegistration" do
      let(:resource) { double(:resource) }

      it "returns false" do
        expect(helper.display_details_link_for?(resource)).to eq(false)
      end
    end

    context "when the resource is a RenewingRegistration" do
      let(:resource) { build(:renewing_registration) }

      it "returns true" do
        expect(helper.display_details_link_for?(resource)).to eq(true)
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
    context "when the resource is not a RenewingRegistration" do
      let(:resource) { build(:registration) }

      it "returns false" do
        expect(helper.display_resume_link_for?(resource)).to eq(false)
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
        before { resource.workflow_state = "renewal_received_form" }

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
          before { allow(helper).to receive(:can?).and_return(false) }

          it "returns false" do
            expect(helper.display_resume_link_for?(resource)).to eq(false)
          end
        end

        context "when the user has permission" do
          before { allow(helper).to receive(:can?).and_return(true) }

          it "returns true" do
            expect(helper.display_resume_link_for?(resource)).to eq(true)
          end
        end
      end
    end
  end

  describe "#display_payment_link_for?" do
    # TODO: Temporary - for release only. See: https://eaflood.atlassian.net/browse/RUBY-846
    # let(:resource) { double(:resource) }

    # before do
    #   expect(resource).to receive(:upper_tier?).and_return(upper_tier)
    # end

    # context "when the resource is an upper tier" do
    #   let(:upper_tier) { true }

    #   it "returns true" do
    #     expect(helper.display_payment_link_for?(resource)).to be_truthy
    #   end
    # end

    # context "when the resource is not an upper tier" do
    #   let(:upper_tier) { false }

    #   it "returns false" do
    #     expect(helper.display_payment_link_for?(resource)).to be_falsey
    #   end
    # end
  end

  describe "#display_cease_or_revoke_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { build(:registration) }

      before do
        allow(helper).to receive(:can?).and_return(can)
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

  describe "#display_edit_link_for?" do
    context "when the resource is a registration" do
      let(:resource) { build(:registration) }

      it "returns false" do
        expect(helper.display_edit_link_for?(resource)).to eq(false)
      end

      # TODO: re-implement when internal route exists https://eaflood.atlassian.net/browse/RUBY-786
      # before do
      #   expect(helper).to receive(:can?).with(:update, WasteCarriersEngine::Registration).and_return(can)
      # end

      # context "when the user has permission for revoking" do
      #   let(:can) { true }

      #   it "returns true" do
      #     expect(helper.display_edit_link_for?(resource)).to be_truthy
      #   end
      # end

      # context "when the user has no permission for revoking" do
      #   let(:can) { false }

      #   it "returns false" do
      #     expect(helper.display_edit_link_for?(resource)).to be_falsey
      #   end
      # end
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
    let(:upper_tier) { true }
    let(:finance_details) { double(:finance_details) }
    let(:resource) { double(:registration, finance_details: finance_details, upper_tier?: upper_tier) }

    # TODO: Temporary - for release only. See: https://eaflood.atlassian.net/browse/RUBY-846
    it "returns false" do
      expect(helper.display_finance_details_link_for?(resource)).to be_falsey
    end

    # context "when the resource is an upper tier" do
    #   context "when the resource has finance details" do
    #     it "returns true" do
    #       expect(helper.display_finance_details_link_for?(resource)).to be_truthy
    #     end
    #   end

    #   context "when the resource has no finance details" do
    #     let(:finance_details) { nil }
    #     it "returns false" do
    #       expect(helper.display_finance_details_link_for?(resource)).to be_falsey
    #     end
    #   end
    # end

    # context "when the resource is not an upper tier" do
    #   let(:upper_tier) { false }

    #   it "returns false" do
    #     expect(helper.display_finance_details_link_for?(resource)).to be_falsey
    #   end
    # end
  end

  describe "#display_convictions_link_for?" do
    context "when the resource is a Registration" do
      let(:resource) { build(:registration) }

      context "when the resource has been revoked" do
        before { resource.metaData.status = "REVOKED" }

        it "returns false" do
          expect(helper.display_convictions_link_for?(resource)).to eq(false)
        end
      end

      context "when the user does not have permission" do
        before { allow(helper).to receive(:can?).and_return(false) }

        it "returns false" do
          expect(helper.display_convictions_link_for?(resource)).to eq(false)
        end
      end

      context "when the user has permission" do
        before { allow(helper).to receive(:can?).and_return(true) }

        context "when the resource has no pending convictions check" do
          let(:resource) { build(:renewing_registration, :does_not_require_conviction_check) }

          it "returns false" do
            expect(helper.display_convictions_link_for?(resource)).to eq(false)
          end
        end

        context "when the resource has a pending convictions check" do
          let(:resource) { build(:renewing_registration, :requires_conviction_check) }

          it "returns true" do
            expect(helper.display_convictions_link_for?(resource)).to eq(true)
          end
        end
      end
    end

    context "when the resource is a RenewingRegistration" do
      let(:resource) { build(:renewing_registration) }

      context "when the resource has been revoked" do
        before { resource.metaData.status = "REVOKED" }

        it "returns false" do
          expect(helper.display_convictions_link_for?(resource)).to eq(false)
        end
      end

      context "when the user does not have permission" do
        before { allow(helper).to receive(:can?).and_return(false) }

        it "returns false" do
          expect(helper.display_convictions_link_for?(resource)).to eq(false)
        end
      end

      context "when the user has permission" do
        before { allow(helper).to receive(:can?).and_return(true) }

        context "when the resource has no pending convictions check" do
          let(:resource) { build(:renewing_registration, :does_not_require_conviction_check) }

          it "returns false" do
            expect(helper.display_convictions_link_for?(resource)).to eq(false)
          end
        end

        context "when the resource has a pending convictions check" do
          let(:resource) { build(:renewing_registration, :requires_conviction_check) }

          it "returns true" do
            expect(helper.display_convictions_link_for?(resource)).to eq(true)
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
            before { allow(helper).to receive(:can?).and_return(false) }

            it "returns false" do
              expect(helper.display_transfer_link_for?(resource)).to eq(false)
            end
          end

          context "when the user has permission" do
            before { allow(helper).to receive(:can?).and_return(true) }

            it "returns true" do
              expect(helper.display_transfer_link_for?(resource)).to eq(true)
            end
          end
        end
      end
    end
  end
end
