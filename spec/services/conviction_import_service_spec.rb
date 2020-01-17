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
Offender,Birth Date,Company No.,System Flag,Inc Number
Apex Limited,,11111111,ABC,99999999
"Doe, John",01/01/1991,,DFG,
)
      end

      it "creates valid business convictions" do
        matching_business_conviction = WasteCarriersEngine::ConvictionsCheck::Entity.where(
          name: "Apex Limited",
          date_of_birth: nil,
          company_number: "11111111",
          system_flag: "ABC",
          incident_number: "99999999"
        )

        expect { run_service }.to change { matching_business_conviction.count }.from(0).to(1)
      end

      it "creates valid person convictions" do
        matching_person_conviction = WasteCarriersEngine::ConvictionsCheck::Entity.where(
          name: "Doe, John",
          date_of_birth: Date.new(1991, 1, 1),
          company_number: nil,
          system_flag: "DFG",
          incident_number: nil
        )

        expect { run_service }.to change { matching_person_conviction.count }.from(0).to(1)
      end
    end
  end

  context "when valid CSV data is not provided" do
    let(:csv) { :not_a_csv }

    it "raises an InvalidCSVError" do
      expect { run_service }.to raise_error(InvalidCSVError)
    end
  end

  context "when the CSV does not contain valid convictions headers" do
    let(:csv) do
      %(
Ingredient,Quantity,Measurement
flour,1,cup
baking soda,2,tablespoons
)
    end

    it "raises an InvalidConvictionDataError" do
      expect { run_service }.to raise_error(InvalidConvictionDataError, "Invalid headers")
    end

    context "when the CSV does not contain offender names" do
      let(:csv) do
        %(
Offender,Birth Date,Company No.,System Flag,Inc Number
,,11111111,ABC,99999999
)
      end

      it "raises an InvalidConvictionDataError" do
        expect { run_service }.to raise_error(InvalidConvictionDataError, "Offender name missing")
      end
    end
  end
end
