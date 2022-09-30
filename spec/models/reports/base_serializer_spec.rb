# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe BaseSerializer do

    # Skip this cop because we need to declare ATTRIBUTES as per the described class.
    # rubocop:disable Lint/ConstantDefinitionInBlock
    class TestObject < Reports::BaseSerializer

      ATTRIBUTES = { reg_identifier: "reg_identifier" }.freeze

      def scope
        ::WasteCarriersEngine::Registration.all # Will not actually be called, just stubbed
      end

      def parse_object(registration)
        [registration.reg_identifier]
      end
    end
    # rubocop:enable Lint/ConstantDefinitionInBlock

    subject { TestObject.new }

    describe "#to_csv" do
      it "returns a csv version of the given data based on attributes" do
        registration = double(:registration)

        allow(registration).to receive(:reg_identifier).and_return("CBDU0000")
        allow(WasteCarriersEngine::Registration).to receive(:all).and_return([registration])

        expect(subject.to_csv).to eq("\"reg_identifier\"\n\"CBDU0000\"\n")
      end
    end
  end
end
