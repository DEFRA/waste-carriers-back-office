# frozen_string_literal: true

require "rails_helper"

RSpec.describe ActionLinksHelper, type: :helper do
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
  end
end
