# frozen_string_literal: true

module Reports
  module Boxi
    class AddressesSerializer < ::Reports::Boxi::BaseSerializer
      ATTRIBUTES = {
        uid: "RegistrationUID",
        address_type: "AddressType",
        uprn: "UPRN",
        house_number: "Premises",
        address_line1: "AddressLine1",
        address_line2: "AddressLine2",
        address_line3: "AddressLine3",
        address_line4: "AddressLine4",
        town_city: "TownCity",
        postcode: "Postcode",
        country: "Country",
        easting: "Easting",
        northing: "Northing",
        first_name: "CorrespondentFirstName",
        last_name: "CorrespondentLastName"
      }.freeze

      def add_entries_for(registration, uid)
        return if registration.addresses.blank?

        registration.addresses.each do |address|
          csv << parse_address(address, uid)
        end
      end

      private

      def parse_address(address, uid)
        ATTRIBUTES.map do |key, _value|
          if key == :uid
            uid
          else
            sanitize(address.public_send(key))
          end
        end
      end

      def file_name
        "addresses.csv"
      end
    end
  end
end
