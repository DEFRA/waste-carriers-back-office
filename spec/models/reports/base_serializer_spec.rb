# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe BaseSerializer do

    let(:test_class) do
      Class.new(described_class) do

        const_set(:ATTRIBUTES, { reg_identifier: "reg_identifier" })

        def scope
          ::WasteCarriersEngine::Registration.all # Will not actually be called, just stubbed
        end

        def parse_object(registration)
          [registration.reg_identifier]
        end
      end
    end

    subject { test_class.new }

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
