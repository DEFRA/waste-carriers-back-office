# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe BaseSerializer do

    class TestObject < Reports::BaseSerializer
      ATTRIBUTES = { reg_identifier: "reg_identifier" }.freeze

      def registrations_scope
        ::WasteCarriersEngine::Registration.all # Will not actually be called, just stubbed
      end

      def parse_registration(registration)
        [registration.reg_identifier]
      end
    end

    subject { TestObject.new }

    describe "#to_csv" do
      it "returns a csv version of the given data based on attributes" do
        registration = double(:registration)

        expect(registration).to receive(:reg_identifier).and_return("CBDU0000")
        expect(WasteCarriersEngine::Registration).to receive(:all).and_return([registration])

        expect(subject.to_csv).to eq("\"reg_identifier\"\n\"CBDU0000\"\n")
      end
    end
  end
end
