# frozen_string_literal: true

require "rails_helper"

RSpec.describe SearchService do
  let(:page) { 1 }
  let(:term) { nil }

  let(:service) do
    SearchService.run(page: page, term: term)
  end

  let(:non_matching_renewal) { create(:transient_registration) }
  let(:non_matching_registration) { WasteCarriersEngine::Registration.where(reg_identifier: non_matching_renewal.reg_identifier).first }

  context "when there is no search term" do
    it "returns no results" do
      expect(service).to eq([])
    end
  end

  context "when there is a search term" do
    let(:matching_renewal) do
      create(:transient_registration)
    end
    let(:matching_registration) { WasteCarriersEngine::Registration.where(reg_identifier: matching_renewal.reg_identifier).first }

    context "when there is a match on a reg_identifier" do
      let(:term) { matching_renewal.reg_identifier }

      it "displays the matching transient_registration" do
        expect(service).to include(matching_renewal)
      end

      it "displays the matching registration" do
        expect(service).to include(matching_registration)
      end

      it "does not display a non-matching transient_registration" do
        expect(service).to_not include(non_matching_renewal)
      end

      it "does not display a non-matching registration" do
        expect(service).to_not include(non_matching_registration)
      end
    end

    context "when there is a match on a company_name" do
      let(:term) { matching_renewal.company_name }

      it "displays the matching transient_registration" do
        expect(service).to include(matching_renewal)
      end

      it "displays the matching registration" do
        expect(service).to include(matching_registration)
      end
    end

    context "when there is a match on a last_name" do
      let(:term) { matching_renewal.last_name }

      it "displays the matching transient_registration" do
        expect(service).to include(matching_renewal)
      end

      it "displays the matching registration" do
        expect(service).to include(matching_registration)
      end
    end

    context "when there is a match on a postcode" do
      let(:term) { matching_renewal.addresses.first.postcode }

      it "displays the matching transient_registration" do
        expect(service).to include(matching_renewal)
      end

      it "displays the matching registration" do
        expect(service).to include(matching_registration)
      end
    end

    context "when the term has a case-insensitive match" do
      let(:term) { matching_renewal.reg_identifier.downcase }

      it "displays the matching transient_registration" do
        expect(service).to include(matching_renewal)
      end

      it "displays the matching registration" do
        expect(service).to include(matching_registration)
      end
    end

    context "when there is a partial match on the reg_identifier" do
      let(:term) { matching_renewal.reg_identifier.chop }

      it "does not include the partially-matching transient_registration" do
        expect(service).to_not include(matching_renewal)
      end

      it "does not include the partially-matching registration" do
        expect(service).to_not include(matching_registration)
      end
    end

    context "when there is a partial match on the last_name" do
      let(:term) { matching_renewal.last_name.chop }

      it "includes the partially-matching transient_registration" do
        expect(service).to include(matching_renewal)
      end

      it "includes the partially-matching registration" do
        expect(service).to include(matching_registration)
      end
    end
  end
end
