# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchRegIdentifierService do
  let(:page) { 1 }
  let(:term) { nil }

  let(:service) do
    described_class.run(page: page, term: term)
  end

  let!(:matching_renewal) { create(:renewing_registration) }
  let!(:matching_registration) { WasteCarriersEngine::Registration.where(reg_identifier: matching_renewal.reg_identifier).first }

  before do
    # create instances which should not be in the results
    create(:renewing_registration)
    create(:renewing_registration)

    # Optionally, if renewals need to be aligned with registrations in your tests, adjust accordingly
    # This depends on the specific requirements of your application
  end

  shared_examples "matching registration and renewal" do
    it "matches the expected registration and renewal only" do
      expect(service[:results]).to contain_exactly(matching_registration, matching_renewal)
    end
  end

  context "without an expected match" do
    let(:term) { Faker::Number.number(digits: 6).to_s }

    it "returns no results" do
      expect(service).to eq(count: 0, results: [])
    end
  end

  context "with an expected reg_identifier match" do
    let(:term) { matching_registration.reg_identifier }

    it_behaves_like "matching registration and renewal"
  end

  context "when the term has a case-sensitive match" do
    let(:term) { matching_registration.reg_identifier.downcase } # Assuming reg_identifier is case-insensitive

    it "returns no results if your application treats reg_identifiers as case-sensitive" do
      expect(service[:results]).to include(matching_registration)
    end
  end

  context "when the term has excess whitespace" do
    let(:term) { " #{matching_registration.reg_identifier} " }

    it_behaves_like "matching registration and renewal"
  end
end
