# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchEmailService do
  let(:page) { 1 }
  let(:term) { nil }

  let(:service) do
    described_class.run(page: page, term: term)
  end

  let(:contact_email) { Faker::Internet.unique.email }
  let(:account_email) { Faker::Internet.unique.email }
  let!(:matching_renewal) { create(:renewing_registration, contact_email: contact_email, account_email: account_email) }
  let!(:matching_registration) { WasteCarriersEngine::Registration.where(reg_identifier: matching_renewal.reg_identifier).first }

  before do
    # create an instance which should not be in the results
    create(:renewing_registration, contact_email: Faker::Internet.unique.email, account_email: Faker::Internet.unique.email)

    # force registration to align with renewing registration
    matching_registration.contact_email = matching_renewal.contact_email
    matching_registration.account_email = matching_renewal.account_email
    matching_registration.save!
  end

  shared_examples "no matches" do
    it "returns no results" do
      expect(service).to eq(count: 0, results: [])
    end
  end

  shared_examples "matching registration and renewal" do
    it "matches the expected registration and renewal only" do
      expect(service[:results]).to contain_exactly(matching_renewal, matching_registration)
    end
  end

  context "when there is no search term" do
    it_behaves_like "no matches"
  end

  context "when there is a search term" do

    context "without an expected match" do
      let(:term) { Faker::Internet.unique.email }

      it_behaves_like "no matches"
    end

    context "with an expected contact_email match" do
      let(:term) { matching_renewal.contact_email }

      it_behaves_like "matching registration and renewal"
    end

    context "with an expected account_email match" do
      let(:term) { matching_renewal.account_email }

      it_behaves_like "matching registration and renewal"
    end

    context "when the term has a case-insensitive match" do
      let(:term) { matching_renewal.contact_email.upcase }

      it_behaves_like "matching registration and renewal"
    end

    context "when the term has excess whitespace" do
      let(:term) { " #{matching_renewal.contact_email} " }

      it_behaves_like "matching registration and renewal"
    end

    context "when there is a match on both the contact_email and account_email" do
      let(:term) { matching_renewal.contact_email }

      before do
        matching_registration.account_email = matching_renewal.contact_email
        matching_registration.save!
      end

      it "returns each matching registration and renewal once only" do
        expect(service[:results]).to contain_exactly(matching_renewal, matching_registration)
      end
    end
  end
end
