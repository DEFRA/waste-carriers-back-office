# frozen_string_literal: true

module Reports
  class EprSerializer < BaseSerializer
    ATTRIBUTES = {
      reg_identifier: "Registration number",
      entity_display_name: "Organisation name",
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
      registrations = ::WasteCarriersEngine::Registration
                      .active_and_expired
                      .lower_tier_or_unexpired_or_in_covid_grace_window

      renewing_registrations = ::WasteCarriersEngine::RenewingRegistration
                               .where("conviction_sign_offs.confirmed": "no")
                               .select do |rr|
        rr.pending_manual_conviction_check? &&
          !rr.pending_payment? &&
          rr.metaData.status != "REVOKED"
      end

      (registrations + renewing_registrations).uniq(&:reg_identifier)
    end

    def parse_object(registration)
      ATTRIBUTES.map do |key, _value|
        presenter = RegistrationEprPresenter.new(registration, nil)
        presenter.public_send(key)
      end
    end
  end
end
