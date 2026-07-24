# frozen_string_literal: true

require "rails_helper"

RSpec.describe EaPublicFaceAreaDataLoadService, type: :service do
  describe ".run" do
    # Loading the full dataset takes several seconds, so run the service once
    # and make all the assertions in a single example
    it "loads the land areas from the fixture" do
      WasteCarriersEngine::EaPublicFaceArea.create!(code: "WSX", name: "an old name", area_id: 0)

      results = described_class.run

      aggregate_failures do
        expect(WasteCarriersEngine::EaPublicFaceArea.count).to eq(14)
        expect(results.count { |result| result[:action] == "updated" }).to eq(1)
        expect(results.count { |result| result[:action] == "created" }).to eq(13)

        wessex = WasteCarriersEngine::EaPublicFaceArea.find_by(code: "WSX")
        expect(wessex.name).to eq("Wessex")
        expect(wessex.area_id).to eq(28)
        expect(wessex.area["type"]).to eq("Polygon")

        index_names = WasteCarriersEngine::EaPublicFaceArea.collection.indexes.pluck("name")
        expect(index_names).to include("area_2dsphere_index")

        # Bristol city centre is in Wessex
        expect(WasteCarriersEngine::DetermineEaAreaService.run(easting: 358_130, northing: 172_688)).to eq("Wessex")
      end
    end
  end
end
