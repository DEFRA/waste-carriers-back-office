# frozen_string_literal: true

require "rails_helper"

RSpec.describe TransientRegistrationSearchService do
  let(:term) { nil }

  let(:in_progress) { false }
  let(:pending_payment) { false }
  let(:pending_conviction_check) { false }

  let(:transient_registrations) do
    service = TransientRegistrationSearchService.new(term,
                                                     in_progress,
                                                     pending_payment,
                                                     pending_conviction_check)
    service.search(1)
  end

  let(:non_matching_renewal) { create(:transient_registration) }

  context "when there are no filters" do
    context "when there is no search term" do
      it "returns no renewals" do
        expect(transient_registrations).to eq([])
      end
    end

    context "when there is a search term" do
      let(:address) { build(:address, postcode: "AB1 2CD") }
      let(:matching_renewal) do
        create(:transient_registration,
               company_name: "Acme",
               last_name: "Aardvark",
               addresses: [address])
      end

      context "when there is a match on a reg_identifier" do
        let(:term) { matching_renewal.reg_identifier }

        it "displays the matching renewal" do
          expect(transient_registrations).to include(matching_renewal)
        end

        it "does not display a non-matching renewal" do
          expect(transient_registrations).to_not include(non_matching_renewal)
        end
      end

      context "when there is a match on a company_name" do
        let(:term) { matching_renewal.company_name }

        it "displays the matching renewal" do
          expect(transient_registrations).to include(matching_renewal)
        end
      end

      context "when there is a match on a last_name" do
        let(:term) { matching_renewal.last_name }

        it "displays the matching renewal" do
          expect(transient_registrations).to include(matching_renewal)
        end
      end

      context "when there is a match on a postcode" do
        let(:term) { address.postcode }

        it "displays the matching renewal" do
          expect(transient_registrations).to include(matching_renewal)
        end
      end

      context "when the term has a case-insensitive match" do
        let(:term) { matching_renewal.reg_identifier.downcase }

        it "includes the matching renewal" do
          expect(transient_registrations).to include(matching_renewal)
        end
      end

      context "when there is a partial match on the reg_identifier" do
        let(:term) { matching_renewal.reg_identifier.chop }

        it "does not include the partial match" do
          expect(transient_registrations).to_not include(matching_renewal)
        end
      end

      context "when there is a partial match on the last_name" do
        let(:term) { matching_renewal.last_name.chop }

        it "includes the partial match" do
          expect(transient_registrations).to include(matching_renewal)
        end
      end
    end
  end

  context "when the in_progress filter is on" do
    let(:in_progress) { true }

    it "displays matching renewals" do
      in_progress_renewal = create(:transient_registration)
      expect(transient_registrations).to include(in_progress_renewal)
    end

    it "does not display non-matching renewals" do
      submitted_renewal = create(:transient_registration, workflow_state: "renewal_received_form")
      expect(transient_registrations).to_not include(submitted_renewal)
    end
  end

  context "when the pending_payment filter is on" do
    let(:pending_payment) { true }

    it "displays matching renewals" do
      pending_payment_renewal = create(:transient_registration, :pending_payment)
      expect(transient_registrations).to include(pending_payment_renewal)
    end

    it "does not display non-matching renewals" do
      paid_renewal = create(:transient_registration, :no_pending_payment)
      expect(transient_registrations).to_not include(paid_renewal)
    end
  end

  context "when the pending_conviction_check filter is on" do
    let(:pending_conviction_check) { true }

    it "displays matching renewals" do
      pending_conviction_check_renewal = create(:transient_registration, :requires_conviction_check)
      expect(transient_registrations).to include(pending_conviction_check_renewal)
    end

    it "does not display non-matching renewals" do
      no_conviction_check_renewal = create(:transient_registration, :does_not_require_conviction_check)
      expect(transient_registrations).to_not include(no_conviction_check_renewal)
    end
  end

  context "when multiple filters are on" do
    let(:pending_payment) { true }
    let(:pending_conviction_check) { true }

    it "displays renewals which match all the filters" do
      matches_both_filters = create(:transient_registration, :pending_payment, :requires_conviction_check)
      expect(transient_registrations).to include(matches_both_filters)
    end

    it "does not display renewals which only match one filter" do
      matches_one_filter = create(:transient_registration, :no_pending_payment, :requires_conviction_check)
      expect(transient_registrations).to_not include(matches_one_filter)
    end
  end

  context "when a search term and a filter are both present" do
    let(:term) { "Acme" }
    let(:pending_payment) { true }

    it "displays renewals which match the search term and filter" do
      matching_search_term_and_filter = create(:transient_registration, :pending_payment, company_name: term)
      expect(transient_registrations).to include(matching_search_term_and_filter)
    end

    it "does not display renewals which only match the search term" do
      matching_search_term = create(:transient_registration, :no_pending_payment, company_name: term)
      expect(transient_registrations).to_not include(matching_search_term)
    end

    it "does not display renewals which only match the filter" do
      matching_filter = create(:transient_registration, :pending_payment)
      expect(transient_registrations).to_not include(matching_filter)
    end
  end
end
