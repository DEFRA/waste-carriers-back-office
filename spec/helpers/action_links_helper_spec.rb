# frozen_string_literal: true

require "rails_helper"

RSpec.describe ActionLinksHelper, type: :helper do
  describe "details_link_for" do
    context "when the resource is a transient_registration" do
      let(:resource) { build(:transient_registration) }

      it "returns the correct path" do
        expect(helper.details_link_for(resource)).to eq(transient_registration_path(resource.reg_identifier))
      end
    end

    context "when the resource is not a transient_registration" do
      let(:resource) { build(:registration) }

      it "returns the correct path" do
        expect(helper.details_link_for(resource)).to eq("#")
      end
    end
  end

  describe "resume_link_for" do
    context "when the resource is a transient_registration" do
      let(:resource) { build(:transient_registration) }

      it "returns the correct path" do
        expect(helper.resume_link_for(resource)).to eq(WasteCarriersEngine::Engine.routes.url_helpers.new_renewal_start_form_path(resource.reg_identifier))
      end
    end

    context "when the resource is not a transient_registration" do
      let(:resource) { build(:registration) }

      it "returns the correct path" do
        expect(helper.resume_link_for(resource)).to eq("#")
      end
    end
  end

  describe "payment_link_for" do
    context "when the resource is a transient_registration" do
      let(:resource) { build(:transient_registration) }

      it "returns the correct path" do
        expect(helper.payment_link_for(resource)).to eq(transient_registration_payments_path(resource.reg_identifier))
      end
    end

    context "when the resource is not a transient_registration" do
      let(:resource) { build(:registration) }

      it "returns the correct path" do
        expect(helper.payment_link_for(resource)).to eq("#")
      end
    end
  end

  describe "convictions_link_for" do
    context "when the resource is a transient_registration" do
      let(:resource) { build(:transient_registration) }

      it "returns the correct path" do
        expect(helper.convictions_link_for(resource)).to eq(transient_registration_convictions_path(resource.reg_identifier))
      end
    end

    context "when the resource is not a transient_registration" do
      let(:resource) { build(:registration) }

      it "returns the correct path" do
        expect(helper.convictions_link_for(resource)).to eq("#")
      end
    end
  end

  describe "renew_link_for" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      it "returns the correct path" do
        expect(helper.renew_link_for(resource)).to eq(WasteCarriersEngine::Engine.routes.url_helpers.new_renewal_start_form_path(resource.reg_identifier))
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { create(:transient_registration) }

      it "returns the correct path" do
        expect(helper.renew_link_for(resource)).to eq("#")
      end
    end
  end

  describe "transfer_link_for" do
    context "when the resource is a registration" do
      let(:resource) { create(:registration) }

      it "returns the correct path" do
        expect(helper.transfer_link_for(resource)).to eq(new_registration_transfer_path(resource.reg_identifier))
      end
    end

    context "when the resource is not a registration" do
      let(:resource) { create(:transient_registration) }

      it "returns the correct path" do
        expect(helper.transfer_link_for(resource)).to eq("#")
      end
    end
  end

  describe "#display_details_link_for?" do
    context "when the result is not a TransientRegistration" do
      let(:result) { build(:registration) }

      it "returns false" do
        expect(helper.display_details_link_for?(result)).to eq(false)
      end
    end

    context "when the result is a TransientRegistration" do
      let(:result) { build(:transient_registration) }

      it "returns true" do
        expect(helper.display_details_link_for?(result)).to eq(true)
      end
    end
  end

  describe "#display_resume_link_for?" do
    context "when the result is not a TransientRegistration" do
      let(:result) { build(:registration) }

      it "returns false" do
        expect(helper.display_resume_link_for?(result)).to eq(false)
      end
    end

    context "when the result is a TransientRegistration" do
      let(:result) { build(:transient_registration) }

      context "when the result has been revoked" do
        before { result.metaData.status = "REVOKED" }

        it "returns false" do
          expect(helper.display_resume_link_for?(result)).to eq(false)
        end
      end

      context "when the result has been submitted" do
        before { result.workflow_state = "renewal_received_form" }

        it "returns false" do
          expect(helper.display_resume_link_for?(result)).to eq(false)
        end
      end

      context "when the result is in WorldPay" do
        before { result.workflow_state = "worldpay_form" }

        it "returns false" do
          expect(helper.display_resume_link_for?(result)).to eq(false)
        end
      end

      context "when the result is in a resumable state" do
        before { result.workflow_state = "location_form" }

        it "returns true" do
          expect(helper.display_resume_link_for?(result)).to eq(true)
        end
      end
    end
  end

  describe "#display_payment_link_for?" do
    context "when the result is not a TransientRegistration" do
      let(:result) { build(:registration) }

      it "returns false" do
        expect(helper.display_payment_link_for?(result)).to eq(false)
      end
    end

    context "when the result is a TransientRegistration" do
      let(:result) { build(:transient_registration) }

      context "when the result has been revoked" do
        before { result.metaData.status = "REVOKED" }

        it "returns false" do
          expect(helper.display_payment_link_for?(result)).to eq(false)
        end
      end

      context "when the result has no pending payment" do
        let(:result) { build(:transient_registration, :no_pending_payment) }

        it "returns false" do
          expect(helper.display_payment_link_for?(result)).to eq(false)
        end
      end

      context "when the result has a pending payment" do
        let(:result) { build(:transient_registration, :pending_payment) }

        it "returns true" do
          expect(helper.display_payment_link_for?(result)).to eq(true)
        end
      end
    end
  end

  describe "#display_convictions_link_for?" do
    context "when the result is not a TransientRegistration" do
      let(:result) { build(:registration) }

      it "returns false" do
        expect(helper.display_convictions_link_for?(result)).to eq(false)
      end
    end

    context "when the result is a TransientRegistration" do
      let(:result) { build(:transient_registration) }

      context "when the result has been revoked" do
        before { result.metaData.status = "REVOKED" }

        it "returns false" do
          expect(helper.display_convictions_link_for?(result)).to eq(false)
        end
      end

      context "when the result has no pending convictions check" do
        let(:result) { build(:transient_registration, :does_not_require_conviction_check) }

        it "returns false" do
          expect(helper.display_convictions_link_for?(result)).to eq(false)
        end
      end

      context "when the result has a pending convictions check" do
        let(:result) { build(:transient_registration, :requires_conviction_check) }

        it "returns true" do
          expect(helper.display_convictions_link_for?(result)).to eq(true)
        end
      end
    end

    describe "#display_renew_link_for?" do
      context "when the result is not a Registration" do
        let(:result) { build(:transient_registration) }

        it "returns false" do
          expect(helper.display_renew_link_for?(result)).to eq(false)
        end
      end

      context "when the result is a Registration" do
        let(:result) { build(:registration) }

        context "when the result cannot begin a renewal" do
          before { allow(result).to receive(:can_start_renewal?).and_return(false) }

          it "returns false" do
            expect(helper.display_renew_link_for?(result)).to eq(false)
          end
        end

        context "when the result can begin a renewal" do
          before { allow(result).to receive(:can_start_renewal?).and_return(true) }

          it "returns true" do
            expect(helper.display_renew_link_for?(result)).to eq(true)
          end
        end
      end
    end

    describe "#display_transfer_link_for?" do
      context "when the result is not a Registration" do
        let(:result) { build(:transient_registration) }

        it "returns false" do
          expect(helper.display_transfer_link_for?(result)).to eq(false)
        end
      end

      context "when the result is a Registration" do
        let(:result) { build(:registration) }

        context "when the result has been revoked or refused" do
          before { result.metaData.status = %w[REVOKED REFUSED].sample }

          it "returns false" do
            expect(helper.display_transfer_link_for?(result)).to eq(false)
          end
        end

        context "when the result is not revoked or refused" do
          before { result.metaData.status = %w[ACTIVE EXPIRED PENDING].sample }

          it "returns true" do
            expect(helper.display_transfer_link_for?(result)).to eq(true)
          end
        end
      end
    end
  end
end
