# frozen_string_literal: true

require "rails_helper"

RSpec.describe ActionLinksHelper, type: :helper do
  describe "#display_resume_link_for?" do
    context "when the result is not a TransientRegistration" do
      let(:result) { build(:registration) }

      it "returns false" do
        expect(helper.display_resume_link_for?(result)).to eq(false)
      end
    end

    context "when the result is a TransientRegistration" do
      let(:result) { build(:transient_registration) }

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
end
