# frozen_string_literal: true

require "rails_helper"

RSpec.describe ConvictionsHelper, type: :helper do
  let(:transient_registration) { build(:transient_registration) }

  before do
    assign(:transient_registration, transient_registration)
  end

  describe "#declared_convictions" do
    context "when the value is not present" do
      before do
        transient_registration.declared_convictions = nil
      end

      it "returns 'unknown'" do
        expect(helper.declared_convictions).to eq("unknown")
      end
    end

    context "when the value is 'yes'" do
      before do
        transient_registration.declared_convictions = "yes"
      end

      it "returns true" do
        expect(helper.declared_convictions).to eq(true)
      end
    end

    context "when the value is 'no'" do
      before do
        transient_registration.declared_convictions = "no"
      end

      it "returns false" do
        expect(helper.declared_convictions).to eq(false)
      end
    end
  end

  describe "#business_convictions" do
    context "when the conviction_search_result is not present" do
      before do
        transient_registration.conviction_search_result = nil
      end

      it "returns 'unknown'" do
        expect(helper.business_convictions).to eq("unknown")
      end
    end

    context "when the conviction_search_result is positive" do
      before do
        transient_registration.conviction_search_result = build(:conviction_search_result, :match_result_yes)
      end

      it "returns true" do
        expect(helper.business_convictions).to eq(true)
      end
    end

    context "when the conviction_search_result is unknown" do
      before do
        transient_registration.conviction_search_result = build(:conviction_search_result, :match_result_unknown)
      end

      it "returns true" do
        expect(helper.business_convictions).to eq(true)
      end
    end

    context "when the conviction_search_result is negative" do
      before do
        transient_registration.conviction_search_result = build(:conviction_search_result, :match_result_no)
      end

      it "returns false" do
        expect(helper.business_convictions).to eq(false)
      end
    end
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
end
