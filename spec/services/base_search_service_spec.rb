# frozen_string_literal: true

require "rails_helper"

RSpec.describe BaseSearchService do

  subject(:run_service) { test_service.run(page: page, term: search_term) }

  let(:test_class) do
    Class.new(described_class) do
      def run(page:, term:); end
    end
  end
  let(:page) { 1 }
  let(:search_term) { "search for me" }
  let(:non_matching_renewal) { create(:renewing_registration) }
  let(:non_matching_registration) { WasteCarriersEngine::Registration.find_by(reg_identifier: non_matching_renewal.reg_identifier) }
  let(:matching_renewal1) { create(:renewing_registration) }
  let(:matching_registration1) { WasteCarriersEngine::Registration.find_by(reg_identifier: matching_renewal1.reg_identifier) }
  let(:matching_renewal2) { create(:renewing_registration) }
  let(:matching_registration2) { WasteCarriersEngine::Registration.find_by(reg_identifier: matching_renewal2.reg_identifier) }
  let(:test_service) { instance_double(test_class) }

  def expected_result_for(entities)
    {
      count: entities.count,
      results: entities
    }
  end

  before do
    allow(test_class).to receive(:new).and_return(test_service)
    allow(test_service).to receive(:run).with(any_args).and_return(count: 0, results: [])
  end

  context "when there is no search term" do
    let(:search_term) { nil }

    it "returns no results" do
      expect(run_service).to eq(count: 0, results: [])
    end
  end

  context "when there is a search term" do

    context "with no matches" do
      it "returns no results" do
        expect(run_service).to eq(count: 0, results: [])
      end
    end

    context "with matches on a single collection" do
      before { allow(test_service).to receive(:run).with(any_args).and_return(expected_result_for([matching_renewal1, matching_renewal2])) }

      it "returns the expected count" do
        expect(run_service[:count]).to eq 2
      end

      it "returns all matches from the collection" do
        expect(run_service[:results]).to contain_exactly(matching_renewal1, matching_renewal2)
      end
    end

    context "with matches on multiple collections" do
      before { allow(test_service).to receive(:run).and_return(expected_result_for([matching_renewal1, matching_registration2])) }

      it "returns the expected count" do
        expect(run_service[:count]).to eq 2
      end

      it "returns aggregated results from the different collections" do
        expect(run_service[:results]).to contain_exactly(matching_renewal1, matching_registration2)
      end
    end

    context "when there is a match on an edit registration" do
      let(:edit_registration) { create(:edit_registration) }
      # Un-stub `run` in the test class to allow search to be stubbed
      let(:test_class) do
        Class.new(described_class) do
          def search(); end
        end
      end

      before do
        allow(test_service).to receive(:search).and_return([
                                                             matching_renewal1.reg_identifier,
                                                             matching_registration2.reg_identifier,
                                                             edit_registration.reg_identifier
                                                           ])
      end

      it "does not include the edit registration" do
        expect(run_service[:results]).not_to include(edit_registration)
      end
    end
  end
end
