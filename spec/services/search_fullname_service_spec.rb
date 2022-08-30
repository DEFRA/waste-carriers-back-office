# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchFullnameService do
  let(:page) { 1 }
  let(:term) { nil }

  let(:service) do
    SearchFullnameService.run(page: page, term: term)
  end

  let(:first_name) { Faker::Name.first_name }
  let(:last_name) { Faker::Name.last_name }
  let!(:matching_renewal) { create(:renewing_registration, first_name: first_name, last_name: last_name) }
  let!(:matching_registration) { WasteCarriersEngine::Registration.where(reg_identifier: matching_renewal.reg_identifier).first }

  before do
    matching_registration.first_name = first_name
    matching_registration.last_name = last_name
    matching_registration.save!
  end

  context "when there is no search term" do
    it "returns no results" do
      expect(service).to eq(count: 0, results: [])
    end
  end

  context "when there is a search term" do

    context "with an expected full name match" do
      let(:term) { "#{first_name} #{last_name}" }

      it "matches the expected registration and renewal only" do
        expect(service[:results]).to contain_exactly(matching_renewal, matching_registration)
      end
    end

    context "when there is a match on a last_name only" do
      let(:term) { last_name }

      it "does not return any results" do
        expect(service[:count]).to eq(0)
      end
    end

    context "when the term has a case-insensitive match" do
      let(:term) { "#{first_name} #{last_name}".upcase }

      it "matches the expected registration and renewal only" do
        expect(service[:results]).to contain_exactly(matching_renewal, matching_registration)
      end
    end

    context "when the term has excess whitespace" do
      let(:term) { " #{first_name} #{last_name} " }

      it "matches the term without whitespace" do
        expect(service[:results]).to include(matching_registration)
      end
    end

    context "when there is a match on a key person" do
      let(:key_first_name) { Faker::Name.first_name }
      let(:key_last_name) { Faker::Name.last_name }
      let(:term) { "#{key_first_name} #{key_last_name}" }

      before do
        matching_registration.key_people[0].first_name = key_first_name
        matching_registration.key_people[0].last_name = key_last_name
        matching_registration.save!
      end

      context "when there is no match on the registration owner" do
        it "matches the expected registration only" do
          expect(service[:results]).to contain_exactly(matching_registration)
        end
      end

      context "when there is a match on both the registration owner and a key person" do
        before do
          matching_registration.first_name = key_first_name
          matching_registration.last_name = key_last_name
          matching_registration.save!
        end

        it "returns the registration once only" do
          expect(service[:results].length).to eq 1
        end
      end
    end
  end
end
