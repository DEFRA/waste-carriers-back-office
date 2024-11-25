# frozen_string_literal: true

module Reports
  class EprSerializer < BaseCsvFileSerializer

    attr_reader :registration_ids

    ATTRIBUTES = {
      reg_identifier: "Registration number",
      entity_display_name: "Organisation name",
      registered_address_uprn: "UPRN",
      registered_address_house_number: "Building",
      registered_address_address_line_1: "Address line 1",
      registered_address_address_line_2: "Address line 2",
      registered_address_address_line_3: "Address line 3",
      registered_address_address_line_4: "Address line 4",
      registered_address_town_city: "Town",
      registered_address_postcode: "Postcode",
      registered_address_country: "Country",
      registered_address_easting: "Easting",
      registered_address_northing: "Northing",
      business_type: "Applicant type",
      tier: "Registration tier",
      registration_type: "Registration type",
      metadata_date_activated: "Registration date",
      expires_on: "Expiry date",
      company_no: "Company number"
    }.freeze

    def initialize(path: nil, processed_ids: nil)
      @processed_ids = processed_ids || Set.new

      super(path)
    end

    private

    def scope
      registrations = ::WasteCarriersEngine::Registration
                      .active_and_expired
                      .lower_tier_or_unexpired

      # Save these for de-duplication purposes in the EprRenewalSerializer subclass
      @registration_ids = registrations.pluck(:reg_identifier).to_set

      registrations
    end

    def parse_object(registration)
      return if already_processed(registration.reg_identifier)

      ATTRIBUTES.map do |key, _value|
        presenter = RegistrationEprPresenter.new(registration, nil)
        presenter.public_send(key)
      end
    end

    def already_processed(registration_id)
      # SonarCloud complains about the unused parameter even with a leading underscore
      # Removing it breaks epr_renewal_serializer. Adding a NOP so that the parameter is referenced.
      registration_id.to_s

      false
    end
  end
end
