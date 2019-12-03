# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConvictionsHelper, type: :helper do
  let(:transient_registration) { build(:renewing_registration) }

  before do
    assign(:resource, transient_registration)
  end

  describe "#people_convictions" do
    context "when there are no key people" do
      before do
        transient_registration.key_people = nil
      end

      it "returns 'unknown'" do
        expect(helper.people_convictions).to eq("unknown")
      end
    end

    context "when there is a key person" do
      let(:person) { build(:key_person) }
      before do
        transient_registration.key_people = [person]
      end

      context "when the conviction_search_result is not present" do
        before do
          person.conviction_search_result = nil
        end

        it "returns 'unknown'" do
          expect(helper.people_convictions).to eq("unknown")
        end
      end

      context "when the conviction_search_result is positive" do
        before do
          person.conviction_search_result = build(:conviction_search_result, :match_result_yes)
        end

        it "returns true" do
          expect(helper.people_convictions).to eq(true)
        end
      end

      context "when the conviction_search_result is unknown" do
        before do
          person.conviction_search_result = build(:conviction_search_result, :match_result_unknown)
        end

        it "returns true" do
          expect(helper.people_convictions).to eq(true)
        end
      end

      context "when the conviction_search_result is negative" do
        before do
          person.conviction_search_result = build(:conviction_search_result, :match_result_no)
        end

        it "returns false" do
          expect(helper.people_convictions).to eq(false)
        end
      end
    end
  end

  describe "#relevant_people_without_matches" do
    context "when there are no relevant people" do
      before do
        transient_registration.key_people = []
      end

      it "returns an empty array" do
        expect(helper.relevant_people_without_matches).to eq([])
      end
    end

    context "when there is a relevant person" do
      let(:person) { build(:key_person, :relevant) }

      before do
        transient_registration.key_people = [person]
      end

      context "when a person has no conviction search result" do
        before do
          person.conviction_search_result = nil
        end

        it "includes the person in the array" do
          expect(helper.relevant_people_without_matches).to eq([person])
        end
      end

      context "when a conviction search result is NO" do
        before do
          person.conviction_search_result = build(:conviction_search_result, :match_result_no)
        end

        it "includes the person in the array" do
          expect(helper.relevant_people_without_matches).to eq([person])
        end
      end

      context "when a conviction search result is YES" do
        before do
          person.conviction_search_result = build(:conviction_search_result, :match_result_yes)
        end

        it "returns an empty array" do
          expect(helper.relevant_people_without_matches).to eq([])
        end
      end

      context "when a conviction search result is UNKNOWN" do
        before do
          person.conviction_search_result = build(:conviction_search_result, :match_result_unknown)
        end

        it "returns an empty array" do
          expect(helper.relevant_people_without_matches).to eq([])
        end
      end
    end
  end
end
