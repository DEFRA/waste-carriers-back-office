# frozen_string_literal: true

require "rails_helper"

module Reports
  module Boxi
    RSpec.describe KeyPersonPresenter do
      let(:key_person) { double(:key_person) }

      subject { described_class.new(key_person, nil) }

      describe "#flagged_for_review" do
        before do
          allow(key_person).to receive(:conviction_search_result).and_return(conviction_search_result)
        end

        context "when there is no conviction_search_result" do
          let(:conviction_search_result) { nil }

          it "returns nil" do
            expect(subject.flagged_for_review).to be_nil
          end
        end

        context "when there is a conviction_search_result" do
          let(:conviction_search_result) { double(:conviction_search_result) }

          it "returns the match result" do
            result = double(:result)

            allow(conviction_search_result).to receive(:match_result).and_return(result)
            expect(subject.flagged_for_review).to eq(result)
          end
        end
      end

      describe "#review_flag_timestamp" do
        before do
          allow(key_person).to receive(:conviction_search_result).and_return(conviction_search_result)
        end

        context "when there is no conviction_search_result" do
          let(:conviction_search_result) { nil }

          it "returns nil" do
            expect(subject.review_flag_timestamp).to be_nil
          end
        end

        context "when there is a conviction_search_result" do
          let(:conviction_search_result) { double(:conviction_search_result) }

          it "returns the match result" do
            searched_at = Time.zone.local(2019, 11, 19)

            allow(conviction_search_result).to receive(:searched_at).and_return(searched_at)
            expect(subject.review_flag_timestamp.to_s).to eq("2019-11-19T00:00Z")
          end
        end
      end

      describe "#date_of_birth" do
        before { allow(key_person).to receive(:dob).and_return(dob) }

        context "with date of birth not populated" do
          let(:dob) { nil }

          it "returns nil" do
            expect(subject.date_of_birth).to be_nil
          end
        end

        context "with date of birth populated" do
          let(:dob) { DateTime.new(1980, 1, 23) }

          it "returns the date of birth in the expected format" do
            expect(subject.date_of_birth).to eq("23/01/1980")
          end
        end
      end
    end
  end
end
