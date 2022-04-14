# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Refresh companies house", type: :request do
  describe "PATCH /bo/registrations/:reg_identifier/companies_house_details" do

    subject { patch registration_companies_house_details_path(registration.reg_identifier) }

    RSpec.shared_examples "all companies house details requests" do

      it "redirects to the same page" do
        subject
        expect(response.status).to eq 302
        expect(response.location).to end_with registration_path(registration.reg_identifier)
      end
    end

    let(:user) { create(:user) }
    let(:new_registered_name) { Faker::Company.name }
    let(:registration) { create(:registration, registered_company_name: old_registered_name) }

    before do
      sign_in(user)
      stub_request(:get, "#{Rails.configuration.companies_house_host}#{registration.company_no}").to_return(
        status: 200,
        body: { company_name: new_registered_name }.to_json
      )
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
    end
  end
end
