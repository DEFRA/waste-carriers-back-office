# frozen_string_literal: true

module Reports
  module Boxi
    class RegistrationsSerializer < ::Reports::Boxi::BaseSerializer
      ATTRIBUTES = {
        uid: "RegistrationUID",
        reg_identifier: "RegistrationNumber",
        original_registration_number: "RenewedRegistrationNumber",
        tier: "Tier",
        business_type: "OrganisationType",
        registration_type: "RegistrationType",
        entity_display_name: "OrganisationName",
        company_no: "CompanyNumber",
        first_name: "ContactFirstName",
        last_name: "ContactLastName",
        phone_number: "ContactPhoneNumber",
        contact_email: "ContactEmail",
        account_email: "AccountEmail",
        metadata_status: "Status",
        finance_details_balance: "Balance",
        metadata_revoked_reason: "RevokedReason",
        metadata_date_registered: "RegistrationTimestamp",
        metadata_date_activated: "ActivationTimestamp",
        expires_on: "ExpiryTimestamp",
        metadata_date_last_modified: "LastModifiedTimestamp",
        metadata_route: "Route",
        other_businesses: "OtherBusinesses",
        is_main_service: "IsMainService",
        construction_waste: "ConstructionWaste",
        only_amf: "OnlyAMF",
        declaration: "Declaration",
        declared_convictions: "DeclaredConvictions",
        conviction_search_result_match_result: "OrganisationFlaggedForReview",
        conviction_search_result_searched_at: "ReviewFlagTimestamp"
      }.freeze

      def add_entries_for(registration, uid)
        csv << parse_registration(registration, uid)
      end

      private

      def parse_registration(registration, uid)
        presenter = RegistrationPresenter.new(registration, nil)

        ATTRIBUTES.map do |key, _value|
          if key == :uid
            uid
          else
            sanitize(presenter.public_send(key))
          end
        end
      end

      def file_name
        "registrations.csv"
      end
    end
  end
end
