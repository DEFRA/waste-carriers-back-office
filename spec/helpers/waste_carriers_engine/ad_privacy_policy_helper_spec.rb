# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe WasteCarriersEngine::AdPrivacyPolicyHelper, type: :helper do
    describe "destination_path" do
      context "when a reg identifier as been defined in the controller" do
        it "returns the renewal start form path" do
          assign(:reg_identifier, "CBDUFOO")

          expect(helper.destination_path).to eq("/bo/CBDUFOO/renew")
        end
      end

      context "when there is no reg identifier available" do
        it "returns the new start form path" do
          expect(helper.destination_path).to eq("/bo/start")
        end
      end
    end
  end
end
