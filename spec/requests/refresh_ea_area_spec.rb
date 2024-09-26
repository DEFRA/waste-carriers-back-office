# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Refresh EA area" do
  describe "PATCH /bo/registrations/:reg_identifier/ea_area" do

    subject(:refresh_ea_area_call) { patch refresh_ea_area_path(registration.reg_identifier) }

    RSpec.shared_examples "all ea area requests" do

      it "redirects to the same page" do
        refresh_ea_area_call
        expect(response).to have_http_status(:found)
        expect(response.location).to end_with registration_path(registration.reg_identifier)
      end

      it "returns a success message" do
        success_message = I18n.t("refresh_ea_area.messages.success")

        refresh_ea_area_call
        follow_redirect!

        expect(response.body).to include(success_message)
      end
    end

    let(:user) { create(:user) }
    let(:company_address) { build(:address, :registered) }
    let(:registration) { create(:registration, company_address: company_address) }
    let(:os_places_data) { JSON.parse(file_fixture("os_places_response.json").read) }

    before do
      sign_in(user)
      allow(WasteCarriersEngine::AddressLookupService).to receive(:run).and_return(
        instance_double(DefraRuby::Address::Response, successful?: true, results: [os_places_data])
      )
    end

    context "with no previous EA area" do
      let(:old_ea_area) { nil }

      it_behaves_like "all ea area requests"
    end

    context "with an existing EA area" do
      let(:old_ea_area) { "Wessex" }

      context "when the new EA area is the same as the old one" do
        let(:new_ea_area) { old_ea_area }

        it_behaves_like "all ea area requests"
      end

      context "when the new EA area is different to the old one" do
        it_behaves_like "all ea area requests"
      end

      context "when an error happens" do
        let(:old_ea_area) { Faker::Company.name }

        before do
          allow(WasteCarriersEngine::UpdateAddressDetailsFromOsPlacesService).to receive(:run).and_raise(StandardError)
        end

        it "returns an error message" do
          error_message = I18n.t("refresh_ea_area.messages.failure")

          refresh_ea_area_call
          follow_redirect!

          expect(response.body).to include(error_message)
        end
      end
    end
  end
end
