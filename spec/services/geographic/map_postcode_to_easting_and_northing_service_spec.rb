# frozen_string_literal: true

# spec/services/waste_carriers_engine/determine_easting_and_northing_service_spec.rb

require "rails_helper"

module Geographic
  RSpec.describe MapPostcodeToEastingAndNorthingService, type: :service do
    let(:service) { described_class.new }
    let(:os_places_data) { JSON.parse(file_fixture("os_places_response.json").read) }
    let(:valid_postcode) { "SW1A 1AA" }
    let(:invalid_postcode) { "INVALID" }

    describe "#run" do
      context "when given a valid postcode" do
        before do
          # Stub AddressLookupService to return a valid response
          allow(WasteCarriersEngine::AddressLookupService).to receive(:run).with(valid_postcode).and_return(
            instance_double(DefraRuby::Address::Response, successful?: true, results: [os_places_data])
          )
        end

        it "returns the correct easting and northing values" do
          result = service.run(postcode: valid_postcode)

          expect(result[:easting]).to eq(358_205.0)
          expect(result[:northing]).to eq(172_708.0)
        end
      end

      context "when given an invalid postcode" do
        before do
          # Stub AddressLookupService to return a NoMatchError
          allow(WasteCarriersEngine::AddressLookupService).to receive(:run).with(invalid_postcode).and_return(
            instance_double(DefraRuby::Address::Response, successful?: false, error: DefraRuby::Address::NoMatchError.new)
          )
        end

        it "returns the default easting and northing values" do
          result = service.run(postcode: invalid_postcode)

          expect(result[:easting]).to eq(0.0)
          expect(result[:northing]).to eq(0.0)
        end
      end

      context "when the postcode lookup service returns an error" do
        before do
          # Stub AddressLookupService to return a generic error
          allow(WasteCarriersEngine::AddressLookupService).to receive(:run).with(invalid_postcode).and_return(
            instance_double(DefraRuby::Address::Response, successful?: false, error: StandardError.new("An error occurred"))
          )
        end

        it "returns the default easting and northing values" do
          result = service.run(postcode: invalid_postcode)

          expect(result[:easting]).to eq(0.0)
          expect(result[:northing]).to eq(0.0)
        end
      end
    end
  end
end
