# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
    RSpec.describe AddressesSerializer do
      let(:dir) { "/tmp/test" }
      let(:csv) { double(:csv) }
      let(:headers) do
        [
          "RegistrationUID",
          "AddressType",
          "UPRN",
          "Premises",
          "AddressLine1",
          "AddressLine2",
          "AddressLine3",
          "AddressLine4",
          "TownCity",
          "Postcode",
          "Country",
          "Easting",
          "Northing",
          "CorrespondentFirstName",
          "CorrespondentLastName"
        ]
      end
      subject { described_class.new(dir) }

      before do
        expect(CSV).to receive(:open).and_return(csv)
        expect(csv).to receive(:<<).with(headers)
      end

      describe "#add_entries_for" do
        let(:registration) { double(:registration) }

        it "creates an entry in the csv for each address in the registration" do
          address = double(:address)

          values = [
            0,
            "address_type",
            "uprn",
            "house_number",
            "address_line_1",
            "address_line_2",
            "address_line_3",
            "address_line_4",
            "town_city",
            "postcode",
            "country",
            "easting",
            "northing",
            "first_name",
            "last_name"
          ]

          expect(registration).to receive(:addresses).and_return([address])
          expect(address).to receive(:address_type).and_return("address_type")
          expect(address).to receive(:uprn).and_return("uprn")
          expect(address).to receive(:house_number).and_return("house_number")
          expect(address).to receive(:address_line_1).and_return("address_line_1")
          expect(address).to receive(:address_line_2).and_return("address_line_2")
          expect(address).to receive(:address_line_3).and_return("address_line_3")
          expect(address).to receive(:address_line_4).and_return("address_line_4")
          expect(address).to receive(:town_city).and_return("town_city")
          expect(address).to receive(:postcode).and_return("postcode")
          expect(address).to receive(:country).and_return("country")
          expect(address).to receive(:easting).and_return("easting")
          expect(address).to receive(:northing).and_return("northing")
          expect(address).to receive(:first_name).and_return("first_name")
          expect(address).to receive(:last_name).and_return("last_name")

          expect(csv).to receive(:<<).with(values)

          subject.add_entries_for(registration, 0)
        end
      end
    end
  end
end
