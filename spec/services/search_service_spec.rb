# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchService do
  let(:page) { 1 }
  let(:term) { nil }

  let(:service) do
    described_class.run(page: page, term: term)
  end

  let(:non_matching_renewal) { create(:renewing_registration) }
  let(:non_matching_registration) { WasteCarriersEngine::Registration.where(reg_identifier: non_matching_renewal.reg_identifier).first }
  let(:matching_renewal) { create(:renewing_registration) }
  let(:matching_registration) { WasteCarriersEngine::Registration.where(reg_identifier: matching_renewal.reg_identifier).first }
  let!(:in_progress_registration) { create(:new_registration, company_name: matching_renewal.company_name) }

  context "when there is a match on a reg_identifier" do
    let(:term) { matching_renewal.reg_identifier }

    it "returns the correct count" do
      expect(service[:count]).to eq(2)
    end

    it "displays the matching transient_registration" do
      expect(service[:results]).to include(matching_renewal)
    end

    it "displays the matching registration" do
      expect(service[:results]).to include(matching_registration)
    end

    it "does not display a non-matching transient_registration" do
      expect(service[:results]).not_to include(non_matching_renewal)
    end

    it "does not display a non-matching registration" do
      expect(service[:results]).not_to include(non_matching_registration)
    end
  end

  context "when there is a match on a company_name" do
    let(:term) { matching_renewal.company_name }

    it "returns the correct count" do
      expect(service[:count]).to eq(3)
    end

    it "displays the matching transient_registration" do
      expect(service[:results]).to include(matching_renewal)
    end

    it "displays the matching registration" do
      expect(service[:results]).to include(matching_registration)
    end

    it "displays the matching in-progress registration" do
      expect(service[:results]).to include(in_progress_registration)
    end
  end

  context "when there is a match on a last_name" do
    let(:term) { matching_renewal.last_name }

    it "returns the correct count" do
      expect(service[:count]).to eq(2)
    end

    it "displays the matching transient_registration" do
      expect(service[:results]).to include(matching_renewal)
    end

    it "displays the matching registration" do
      expect(service[:results]).to include(matching_registration)
    end
  end

  context "when there is a match on a postcode" do
    let(:term) { matching_renewal.addresses.first.postcode }

    it "returns the correct count" do
      expect(service[:count]).to eq(2)
    end

    it "displays the matching transient_registration" do
      expect(service[:results]).to include(matching_renewal)
    end

    it "displays the matching registration" do
      expect(service[:results]).to include(matching_registration)
    end
  end

  context "when the term has a case-insensitive match" do
    let(:term) { matching_renewal.reg_identifier.downcase }

    it "returns the correct count" do
      expect(service[:count]).to eq(2)
    end

    it "displays the matching transient_registration" do
      expect(service[:results]).to include(matching_renewal)
    end

    it "displays the matching registration" do
      expect(service[:results]).to include(matching_registration)
    end
  end

  context "when there is a partial match on the reg_identifier" do
    let(:term) { matching_renewal.reg_identifier.chop }

    it "returns the correct count" do
      expect(service[:count]).to eq(0)
    end

    it "does not include the partially-matching transient_registration" do
      expect(service[:results]).not_to include(matching_renewal)
    end

    it "does not include the partially-matching registration" do
      expect(service[:results]).not_to include(matching_registration)
    end
  end

  context "when there is a partial match on the last_name" do
    let(:term) { matching_renewal.last_name.chop }

    it "returns the correct count" do
      expect(service[:count]).to eq(2)
    end

    it "includes the partially-matching transient_registration" do
      expect(service[:results]).to include(matching_renewal)
    end

    it "includes the partially-matching registration" do
      expect(service[:results]).to include(matching_registration)
    end
  end

  context "when the term has excess whitespace" do
    let(:term) { " #{matching_registration.reg_identifier} " }

    it "matches the term without whitespace" do
      expect(service[:results]).to include(matching_registration)
    end
  end

  context "when there is a match on telephone number" do
    let(:term) { matching_renewal.phone_number }

    it "returns the correct count" do
      expect(service[:count]).to eq(2)
    end

    it "displays the matching transient_registration" do
      expect(service[:results]).to include(matching_renewal)
    end

    it "displays the matching registration" do
      expect(service[:results]).to include(matching_registration)
    end

    it "does not display a non-matching transient_registration" do
      expect(service[:results]).not_to include(non_matching_renewal)
    end

    it "does not display a non-matching registration" do
      expect(service[:results]).not_to include(non_matching_registration)
    end
  end
end
