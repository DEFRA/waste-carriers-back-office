# frozen_string_literal: true

require "rails_helper"

RSpec.describe DashboardsHelper, type: :helper do
  let(:result) { build(:transient_registration) }

  describe "#inline_registration_address" do
    context "when the address is not present" do
      before do
        result.addresses = nil
      end

      it "returns nil" do
        expect(helper.inline_registered_address(result)).to eq(nil)
      end
    end

    context "when the address is present" do
      it "returns the correct value" do
        expect(helper.inline_registered_address(result)).to eq("42, Foo Gardens, Baz City, FA1 1KE")
      end
    end
  end

  describe "#result_type" do
    context "when the result is a TransientRegistration" do
      let(:result) { build(:transient_registration) }

      it "returns 'renewal'" do
        expect(helper.result_type(result)).to eq("renewal")
      end
    end

    context "when the result is not a TransientRegistration" do
      let(:result) { build(:registration) }

      it "returns nil" do
        expect(helper.result_type(result)).to eq(nil)
      end
    end
  end

  describe "#can_be_resumed?" do
    context "when the result is not a TransientRegistration" do
      let(:result) { build(:registration) }

      it "returns false" do
        expect(helper.can_be_resumed?(result)).to eq(false)
      end
    end

    context "when the result is a TransientRegistration" do
      let(:result) { build(:transient_registration) }

      context "when the result has been submitted" do
        before { result.workflow_state = "renewal_received_form" }

        it "returns false" do
          expect(helper.can_be_resumed?(result)).to eq(false)
        end
      end

      context "when the result is in WorldPay" do
        before { result.workflow_state = "worldpay_form" }

        it "returns false" do
          expect(helper.can_be_resumed?(result)).to eq(false)
        end
      end

      context "when the result is in a resumable state" do
        before { result.workflow_state = "location_form" }

        it "returns true" do
          expect(helper.can_be_resumed?(result)).to eq(true)
        end
      end
    end
  end
end
