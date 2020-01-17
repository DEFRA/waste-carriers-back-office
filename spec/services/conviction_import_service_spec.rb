# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConvictionImportService do
  let(:csv) {}
  let(:run_service) do
    ConvictionImportService.run(csv)
  end

  describe "#run" do
    context "when given CSV in a string as an argument" do
      let(:csv) do
        %(
Apex Limited,,11111111,ABC,99999999
"Doe, John",01/01/1991,,DFG,
)
      end

      it "returns an array of arrays" do
        array_data = [
          ["Apex Limited", nil, "11111111", "ABC", "99999999"],
          ["Doe, John", "01/01/1991", nil, "DFG", nil]
        ]

        expect(run_service).to eq(array_data)
      end
    end
  end
end
