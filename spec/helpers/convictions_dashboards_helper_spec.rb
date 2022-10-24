# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConvictionsDashboardsHelper do
  describe "#details_path" do
    let(:resource) { nil }
    let(:path) { helper.details_path(resource) }

    context "when the resource is a registration" do
      let(:resource) { WasteCarriersEngine::Registration.new(reg_identifier: "CBDU1") }

      it "returns the correct path" do
        expected_path = registration_convictions_path(resource.reg_identifier)

        expect(path).to eq(expected_path)
      end
    end

    context "when the resource is a renewing_registration" do
      let(:resource) { WasteCarriersEngine::RenewingRegistration.new(reg_identifier: "CBDU1") }

      it "returns the correct path" do
        expected_path = transient_registration_convictions_path(resource.reg_identifier)

        expect(path).to eq(expected_path)
      end
    end
  end
end
