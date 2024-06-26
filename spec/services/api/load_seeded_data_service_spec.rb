# frozen_string_literal: true

require "rails_helper"

module Api
  RSpec.describe LoadSeededDataService do
    describe ".run" do
      it "creates a new registration after assigning a new reg_identifier" do
        seed = { "tier" => "UPPER" }

        registration = double(:registration)

        allow(WasteCarriersEngine::Registration).to receive(:find_or_create_by).and_return(registration)
        allow(WasteCarriersEngine::GenerateRegIdentifierService).to receive(:run).and_return(1)
        allow(Rails.configuration).to receive(:expires_after).and_return(3)

        expect(described_class.run(seed)).to eq(registration)
      end
    end
  end
end
