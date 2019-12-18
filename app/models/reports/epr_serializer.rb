# frozen_string_literal: true

module Reports
  class EprSerializer < BaseSerializer
    ATTRIBUTES = {
      reg_identifier: "Registration number",
      company_name: "Organisation name",
      company_address_uprn: "UPRN",
      company_address_house_number: "Building",
      company_address_address_line_1: "Address line 1",
      company_address_address_line_2: "Address line 2",
      company_address_address_line_3: "Address line 3",
      company_address_address_line_4: "Address line 4",
      company_address_town_city: "Town",
      company_address_postcode: "Postcode",
      company_address_country: "Country",
      company_address_easting: "Easting",
      company_address_northing: "Northing",
      business_type: "Applicant type",
      tier: "Registration tier",
      registration_type: "Registration type",
      metadata_date_activated: "Registration date",
      expires_on: "Expiry date",
      company_no: "Company number"
    }.freeze

    private

    def scope
      ::WasteCarriersEngine::Registration.active
    end

    def parse_object(registration)
      ATTRIBUTES.map do |key, _value|
        presenter = RegistrationEprPresenter.new(registration, nil)
        presenter.public_send(key)
      end
    end
  end
end
