# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
    RSpec.describe RegistrationsSerializer do
      let(:dir) { "/tmp/test" }
      let(:csv) { double(:csv) }
      let(:headers) do
        %w[
          RegistrationUID
          RegistrationNumber
          RenewedRegistrationNumber
          Tier
          OrganisationType
          RegistrationType
          OrganisationName
          CompanyNumber
          ContactFirstName
          ContactLastName
          ContactPhoneNumber
          ContactEmail
          AccountEmail
          Status
          Balance
          RevokedReason
          RegistrationTimestamp
          ActivationTimestamp
          ExpiryTimestamp
          LastModifiedTimestamp
          Route
          OtherBusinesses
          IsMainService
          ConstructionWaste
          OnlyAMF
          Declaration
          DeclaredConvictions
          OrganisationFlaggedForReview
          ReviewFlagTimestamp
        ]
      end
      subject { described_class.new(dir) }

      describe "#add_entries_for" do
        let(:registration) { double(:registration) }

        it "creates an entry in the csv for each registration" do
          presenter = double(:presenter)

          values = [
            0,
            "reg_identifier",
            "original_registration_number",
            "tier",
            "business_type",
            "registration_type",
            "company_name",
            "company_no",
            "first_name",
            "last_name",
            "phone_number",
            "contact_email",
            "account_email",
            "metadata_status",
            "finance_details_balance",
            "metadata_revoked_reason",
            "metadata_date_registered",
            "metadata_date_activated",
            "expires_on",
            "metadata_date_last_modified",
            "metadata_route",
            "other_businesses",
            "is_main_service",
            "construction_waste",
            "only_amf",
            "declaration",
            "declared_convictions",
            "conviction_search_result_match_result",
            "conviction_search_result_searched_at"
          ]

          expect(RegistrationPresenter).to receive(:new).with(registration, nil).and_return(presenter)

          expect(presenter).to receive(:reg_identifier).and_return("reg_identifier")
          expect(presenter).to receive(:original_registration_number).and_return("original_registration_number")
          expect(presenter).to receive(:tier).and_return("tier")
          expect(presenter).to receive(:business_type).and_return("business_type")
          expect(presenter).to receive(:registration_type).and_return("registration_type")
          expect(presenter).to receive(:entity_display_name).and_return("company_name")
          expect(presenter).to receive(:company_no).and_return("company_no")
          expect(presenter).to receive(:first_name).and_return("first_name")
          expect(presenter).to receive(:last_name).and_return("last_name")
          expect(presenter).to receive(:phone_number).and_return("phone_number")
          expect(presenter).to receive(:contact_email).and_return("contact_email")
          expect(presenter).to receive(:account_email).and_return("account_email")
          expect(presenter).to receive(:metadata_status).and_return("metadata_status")
          expect(presenter).to receive(:metadata_revoked_reason).and_return("metadata_revoked_reason")
          expect(presenter).to receive(:finance_details_balance).and_return("finance_details_balance")
          expect(presenter).to receive(:metadata_date_registered).and_return("metadata_date_registered")
          expect(presenter).to receive(:metadata_date_activated).and_return("metadata_date_activated")
          expect(presenter).to receive(:expires_on).and_return("expires_on")
          expect(presenter).to receive(:metadata_date_last_modified).and_return("metadata_date_last_modified")
          expect(presenter).to receive(:metadata_route).and_return("metadata_route")
          expect(presenter).to receive(:other_businesses).and_return("other_businesses")
          expect(presenter).to receive(:is_main_service).and_return("is_main_service")
          expect(presenter).to receive(:construction_waste).and_return("construction_waste")
          expect(presenter).to receive(:only_amf).and_return("only_amf")
          expect(presenter).to receive(:declaration).and_return("declaration")
          expect(presenter).to receive(:declared_convictions).and_return("declared_convictions")
          expect(presenter).to receive(:conviction_search_result_match_result).and_return("conviction_search_result_match_result")
          expect(presenter).to receive(:conviction_search_result_searched_at).and_return("conviction_search_result_searched_at")

          expect(CSV).to receive(:open).and_return(csv)
          expect(csv).to receive(:<<).with(headers)
          expect(csv).to receive(:<<).with(values)

          subject.add_entries_for(registration, 0)
        end

        it "sanitize data before inserting them in the csv" do
          presenter = double(:presenter, metadata_revoked_reason: " string to\r\nsanitize\n").as_null_object

          allow(RegistrationPresenter).to receive(:new).with(registration, nil).and_return(presenter)

          allow(CSV).to receive(:open).and_return(csv)
          allow(csv).to receive(:<<).with(headers)

          expect(csv).to receive(:<<).with(array_including("string to sanitize"))

          subject.add_entries_for(registration, 0)
        end
      end
    end
  end
end
