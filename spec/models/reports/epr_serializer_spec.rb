# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe EprSerializer do
    subject { described_class.new }

    describe "#to_csv" do
      it "returns a csv version of the given data based on attributes" do
        registration = double(:registration)

        expect(registration).to receive(:reg_identifier).and_return("CBDU0000")
        expect(WasteCarriersEngine::Registration).to receive(:all).and_return([registration])

        expect(subject.to_csv).to eq("reg_identifier\nCBDU0000\n")
      end
    end
  end
end
