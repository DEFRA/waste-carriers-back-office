# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConvictionImportService do
  let(:csv) { nil }
  let(:run_service) do
    described_class.run(csv)
  end

  describe "#run" do
    let(:old_conviction_name) { "Old Conviction" }

    before do
      WasteCarriersEngine::ConvictionsCheck::Entity.new(name: old_conviction_name).save
    end

    context "when given CSV in a string as an argument" do
      let(:csv) do
        %(
Offender,Birth Date,Company No.,System Flag,Inc Number
Apex Limited,,11111111,ABC,99999999
"Doe, John",01/01/1991,,DFG,
   Whitespace Inc   , , , ,
"Birthday, Missing",,,XYZ
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
        matching_no_birthdate_conviction = WasteCarriersEngine::ConvictionsCheck::Entity.where(
          name: "Birthday, Missing",
          date_of_birth: nil,
          company_number: nil,
          system_flag: "XYZ",
          incident_number: nil
        )

        expect { run_service }.to change { matching_person_conviction.count }.from(0).to(1).and change { matching_no_birthdate_conviction.count }.from(0).to(1)
      end

      it "trims excess whitespace" do
        matching_trimmed_conviction = WasteCarriersEngine::ConvictionsCheck::Entity.where(
          name: "Whitespace Inc",
          date_of_birth: nil,
          company_number: nil,
          system_flag: nil,
          incident_number: nil
        )

        expect { run_service }.to change { matching_trimmed_conviction.count }.from(0).to(1)
      end

      it "destroys the old convictions" do
        old_conviction = WasteCarriersEngine::ConvictionsCheck::Entity.where(name: old_conviction_name)

        expect { run_service }.to change { old_conviction.count }.from(1).to(0)
      end
    end

    context "when the CSV contains unexpected additional headers" do
      let(:csv) do
        %(
Offender,Birth Date,Company No.,System Flag,Inc Number,Unexpected Header
Apex Limited,,11111111,ABC,99999999,Extra Data
)
      end

      it "ignores the unexpected headers and processes valid convictions" do
        matching_business_conviction = WasteCarriersEngine::ConvictionsCheck::Entity.where(
          name: "Apex Limited",
          date_of_birth: nil,
          company_number: "11111111",
          system_flag: "ABC",
          incident_number: "99999999"
        )
        expect { run_service }.to change(matching_business_conviction, :count).by(1)

        new_conviction = WasteCarriersEngine::ConvictionsCheck::Entity.where(name: "Apex Limited").first
        expect(new_conviction).not_to be_nil
        expect(new_conviction.company_number).to eq("11111111")
      end
    end

    context "when the CSV contains the headers in a different order" do
      let(:csv) do
        %(
Company No.,System Flag,Inc Number,Offender,Birth Date
11111111,ABC,99999999,Apex Limited,
)
      end

      it "processes the CSV correctly regardless of the header order" do
        matching_business_conviction = WasteCarriersEngine::ConvictionsCheck::Entity.where(
          name: "Apex Limited",
          date_of_birth: nil,
          company_number: "11111111",
          system_flag: "ABC",
          incident_number: "99999999"
        )
        expect { run_service }.to change(matching_business_conviction, :count).by(1)

        new_conviction = WasteCarriersEngine::ConvictionsCheck::Entity.where(name: "Apex Limited").first
        expect(new_conviction).not_to be_nil
        expect(new_conviction.company_number).to eq("11111111")
      end
    end

    context "when the CSV contains an empty header" do
      let(:csv) do
        %(
Offender,Birth Date,Company No.,System Flag,Inc Number,
Apex Limited,,11111111,ABC,99999999,
)
      end

      it "processes the CSV correctly ignoring the empty header" do
        matching_business_conviction = WasteCarriersEngine::ConvictionsCheck::Entity.where(
          name: "Apex Limited",
          date_of_birth: nil,
          company_number: "11111111",
          system_flag: "ABC",
          incident_number: "99999999"
        )
        expect { run_service }.to change(matching_business_conviction, :count).by(1)

        new_conviction = WasteCarriersEngine::ConvictionsCheck::Entity.where(name: "Apex Limited").first
        expect(new_conviction).not_to be_nil
        expect(new_conviction.company_number).to eq("11111111")
      end
    end

    context "when valid CSV data is not provided" do
      # Use an object with a close method so that forwardable does not complain about forwarding to a private method.
      let(:test_class) do
        Class.new(described_class) do
          def close; end
        end
      end

      let(:csv) { test_class.new }

      it "raises an InvalidCSVError and doesn't update any conviction data" do
        old_conviction = WasteCarriersEngine::ConvictionsCheck::Entity.where(name: old_conviction_name)

        expect { run_service }.to raise_error(InvalidCSVError)
        expect do
          run_service
        rescue InvalidCSVError
          Rails.logger.debug "rescued expected exception"
        end.not_to change { old_conviction.count }
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

      it "raises an InvalidConvictionDataError and doesn't update any conviction data" do
        expected_error_message = "Invalid headers, missing Offender, Birth Date, Company No., System Flag, Inc Number"
        expect { run_service }.to raise_error(InvalidConvictionDataError, expected_error_message)

        old_conviction = WasteCarriersEngine::ConvictionsCheck::Entity.where(name: old_conviction_name)
        expect do
          run_service
        rescue InvalidConvictionDataError
          Rails.logger.debug "rescued expected exception"
        end.not_to change { old_conviction.count }
      end

      context "when the CSV does not contain offender names" do
        let(:csv) do
          %(
Offender,Birth Date,Company No.,System Flag,Inc Number
Apex Limited,,11111111,ABC,99999999
,,11111111,ABC,99999999
)
        end

        it "raises an InvalidConvictionDataError and doesn't update any conviction data" do
          old_conviction = WasteCarriersEngine::ConvictionsCheck::Entity.where(name: old_conviction_name)
          new_conviction = WasteCarriersEngine::ConvictionsCheck::Entity.where(name: "Apex Limited")

          expect { run_service }.to raise_error(InvalidConvictionDataError, "Offender name missing")
          expect do
            run_service
          rescue InvalidConvictionDataError
            Rails.logger.debug "rescued expected exception"
          end.not_to change { old_conviction.count }
          expect do
            run_service
          rescue InvalidConvictionDataError
            Rails.logger.debug "rescued expected exception"
          end.not_to change { new_conviction.count }
        end
      end

      context "when the CSV contains an invalid date" do
        let(:csv) do
          %(
Offender,Birth Date,Company No.,System Flag,Inc Number
"Doe, John",notadate,,DFG,
)
        end

        it "raises an InvalidConvictionDataError and doesn't update any conviction data" do
          old_conviction = WasteCarriersEngine::ConvictionsCheck::Entity.where(name: old_conviction_name)
          new_conviction = WasteCarriersEngine::ConvictionsCheck::Entity.where(name: "Doe, John")

          expect { run_service }.to raise_error(InvalidConvictionDataError, "Invalid date of birth")
          expect do
            run_service
          rescue InvalidConvictionDataError
            Rails.logger.debug "rescued expected exception"
          end.not_to change { old_conviction.count }
          expect do
            run_service
          rescue InvalidConvictionDataError
            Rails.logger.debug "rescued expected exception"
          end.not_to change { new_conviction.count }
        end
      end
    end
  end
end
