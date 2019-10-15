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

  describe "#result_date" do
    context "when the result is refused or revoked" do
      before { result.metaData.status = %w[REFUSED REVOKED].sample }

      it "returns nil" do
        expect(helper.result_date(result)).to eq(nil)
      end
    end

    context "when the result is active" do
      before { result.metaData.status = "ACTIVE" }

      it "returns the expected text" do
        date = Date.today.strftime("%d/%m/%Y")
        expect(helper.result_date(result)).to eq("Started #{date}")
      end
    end
  end
end
