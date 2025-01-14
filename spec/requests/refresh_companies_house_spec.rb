# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Refresh companies house" do
  describe "PATCH /bo/registrations/:reg_identifier/companies_house_details" do

    subject { patch refresh_companies_house_name_path(registration.reg_identifier) }

    RSpec.shared_examples "all companies house details requests" do

      it "redirects to the same page" do
        subject
        expect(response).to have_http_status(:found)
        expect(response.location).to end_with registration_path(registration.reg_identifier)
      end

      it "returns a success message" do
        success_message = I18n.t("refresh_companies_house_name.messages.success")

        subject
        follow_redirect!

        expect(response.body).to include(success_message)
      end
    end

    let(:user) { create(:user) }
    let(:new_registered_name) { Faker::Company.name }
    let(:registration) { create(:registration, registered_company_name: old_registered_name) }
    let(:companies_house_api) { instance_double(DefraRuby::CompaniesHouse::API) }
    let(:companies_house_api_response) do
      {
        company_name: Faker::Company.name,
        registered_office_address: ["10 Downing St", "Horizon House", "Bristol", "BS1 5AH"]
      }
    end

    before do
      allow(DefraRuby::CompaniesHouse::API).to receive(:new).and_return(companies_house_api)
      allow(companies_house_api).to receive(:run).and_return(companies_house_api_response)

      sign_in(user)
    end

    context "with no previous companies house name" do
      let(:old_registered_name) { nil }

      it_behaves_like "all companies house details requests"
    end

    context "with an existing registered company name" do
      let(:old_registered_name) { Faker::Company.name }

      context "when the new company name is the same as the old one" do
        let(:new_registered_name) { old_registered_name }

        it_behaves_like "all companies house details requests"
      end

      context "when the new company name is different to the old one" do
        it_behaves_like "all companies house details requests"
      end

      context "when an error happens" do
        let(:old_registered_name) { Faker::Company.name }

        before do
          allow(WasteCarriersEngine::RefreshCompaniesHouseNameService).to receive(:run).and_raise(StandardError)
        end

        it "returns an error message" do
          error_message = I18n.t("refresh_companies_house_name.messages.failure")

          subject
          follow_redirect!

          expect(response.body).to include(error_message)
        end
      end
    end
  end
end
