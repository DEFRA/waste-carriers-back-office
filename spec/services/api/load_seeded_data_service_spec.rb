# frozen_string_literal: true

require "rails_helper"

module Api
  RSpec.describe LoadSeededDataService do
    describe ".run" do
      it "creates a new registration after assigning a new reg_identifier" do
        seed = {}
        registration = double(:registration)

        expect(WasteCarriersEngine::Registration).to receive(:find_or_create_by).and_return(registration)
        expect(WasteCarriersEngine::GenerateRegIdentifierService).to receive(:run).and_return(1)
        expect(Rails.configuration).to receive(:expires_after).and_return(3)

        expect(described_class.run(seed)).to eq(registration)
      end
    end
  end
end
