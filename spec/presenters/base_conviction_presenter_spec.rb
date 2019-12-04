# frozen_string_literal: true

require "rails_helper"

RSpec.describe BaseConvictionPresenter do
  let(:conviction_search_result) {}
  let(:conviction_sign_off) { double(:conviction_sign_off, workflow_state: "possible_match") }
  let(:conviction_sign_offs) { [conviction_sign_off] }

  let(:declared_convictions) {}

  let(:conviction_check_required) { false }
  let(:key_person) do
    double(:key_person,
           conviction_check_required?: conviction_check_required)
  end
  let(:key_people) { [key_person] }
  let(:relevant_people) {}

  let(:business_has_matching_or_unknown_conviction) {}
  let(:conviction_check_approved) {}
  let(:key_person_has_matching_or_unknown_conviction) {}
  let(:revoked) {}

  let(:registration) do
    double(:registration,
           # Attributes and relations
           conviction_search_result: conviction_search_result,
           conviction_sign_offs: conviction_sign_offs,
           declared_convictions: declared_convictions,
           key_people: key_people,
           relevant_people: relevant_people,
           # Method responses
           business_has_matching_or_unknown_conviction?: business_has_matching_or_unknown_conviction,
           conviction_check_approved?: conviction_check_approved,
           key_person_has_matching_or_unknown_conviction?: key_person_has_matching_or_unknown_conviction,
           revoked?: revoked)
  end

  let(:view_context) { double(:view_context) }
  subject { described_class.new(registration, view_context) }

  describe "#sign_off" do
    context "when the conviction_sign_off is not present" do
      let(:conviction_sign_offs) { [] }

      it "returns nil" do
        expect(subject.sign_off).to eq(nil)
      end
    end

    context "when a conviction_sign_off is present" do
      it "returns the conviction_sign_off" do
        expect(subject.sign_off).to eq(conviction_sign_off)
      end
    end
  end

  describe "#conviction_status_message" do
    context "when a conviction_sign_off is present" do
      it "returns the correct message" do
        message = "This registration may have matching or declared convictions and requires an initial review."

        expect(subject.conviction_status_message).to eq(message)
      end
    end

    context "when a conviction_sign_off is not present" do
      let(:conviction_sign_offs) { [] }

      it "returns the correct message" do
        message = "This registration does not require a conviction check before it can be approved."

        expect(subject.conviction_status_message).to eq(message)
      end
    end
  end

  describe "#declared_convictions_message" do
    context "when declared_convictions is 'yes'" do
      let(:declared_convictions) { "yes" }

      it "returns the correct message" do
        message = "Yes – the user declared there were relevant convictions."

        expect(subject.declared_convictions_message).to eq(message)
      end
    end

    context "when declared_convictions is 'no'" do
      let(:declared_convictions) { "no" }

      it "returns the correct message" do
        message = "No – the user said there were no relevant convictions to declare."

        expect(subject.declared_convictions_message).to eq(message)
      end
    end

    context "when declared_convictions is blank" do
      let(:declared_convictions) {}

      it "returns the correct message" do
        message = "Unknown – the user has not answered this question yet."

        expect(subject.declared_convictions_message).to eq(message)
      end
    end
  end

  describe "#business_convictions_message" do
    context "when conviction_search_result is missing" do
      let(:conviction_search_result) {}

      it "returns the correct message" do
        message = "Unknown – the automated conviction checks have not run yet. This may be because the registration application is still in progress."

        expect(subject.business_convictions_message).to eq(message)
      end
    end

    context "when conviction_search_result is present" do
      let(:conviction_search_result) { double(:conviction_search_result) }

      context "when business_has_matching_or_unknown_conviction? is true" do
        let(:business_has_matching_or_unknown_conviction) { true }

        it "returns the correct message" do
          message = "There is a possible matching conviction for the business:"

          expect(subject.business_convictions_message).to eq(message)
        end
      end

      context "when business_has_matching_or_unknown_conviction? is false" do
        let(:business_has_matching_or_unknown_conviction) { false }

        it "returns the correct message" do
          message = "No matching convictions were found for the business."

          expect(subject.business_convictions_message).to eq(message)
        end
      end
    end
  end

  describe "#people_convictions_message" do
    context "when there are no key people" do
      let(:key_people) { [] }

      it "returns the correct message" do
        message = "Unknown – the automated conviction checks have not run yet. This may be because the registration application is still in progress."

        expect(subject.people_convictions_message).to eq(message)
      end
    end

    context "when there are key people" do
      context "when conviction_search_result is not present" do
        let(:key_person) { double(:key_person, conviction_search_result: nil) }

        it "returns the correct message" do
          message = "Unknown – the automated conviction checks have not run yet. This may be because the registration application is still in progress."

          expect(subject.people_convictions_message).to eq(message)
        end
      end

      context "when conviction_search_result is present" do
        let(:conviction_search_result) { double(:conviction_search_result) }
        let(:key_person) { double(:key_person, conviction_search_result: conviction_search_result) }

        context "when key_person_has_matching_or_unknown_conviction? is true" do
          let(:key_person_has_matching_or_unknown_conviction) { true }

          it "returns the correct message" do
            message = "There are possible matching convictions for the following people:"

            expect(subject.people_convictions_message).to eq(message)
          end
        end

        context "when key_person_has_matching_or_unknown_conviction? is false" do
          let(:key_person_has_matching_or_unknown_conviction) { false }

          it "returns the correct message" do
            message = "No matching convictions were found for people."

            expect(subject.people_convictions_message).to eq(message)
          end
        end
      end
    end
  end

  describe "#display_business_convictions?" do
    context "when conviction_search_result is missing" do
      let(:conviction_search_result) {}

      it "returns false" do
        expect(subject.display_business_convictions?).to eq(false)
      end
    end

    context "when conviction_search_result is present" do
      let(:conviction_search_result) { double(:conviction_search_result) }

      context "when business_has_matching_or_unknown_conviction? is true" do
        let(:business_has_matching_or_unknown_conviction) { true }

        it "returns true" do
          expect(subject.display_business_convictions?).to eq(true)
        end
      end

      context "when business_has_matching_or_unknown_conviction? is false" do
        let(:business_has_matching_or_unknown_conviction) { false }

        it "returns false" do
          expect(subject.display_business_convictions?).to eq(false)
        end
      end
    end
  end

  describe "#display_people_convictions?" do
    context "when there are no key people" do
      let(:key_people) { [] }

      it "returns false" do
        expect(subject.display_people_convictions?).to eq(false)
      end
    end

    context "when there are key people" do
      context "when conviction_search_result is not present" do
        let(:key_person) { double(:key_person, conviction_search_result: nil) }

        it "returns false" do
          expect(subject.display_people_convictions?).to eq(false)
        end
      end

      context "when conviction_search_result is present" do
        let(:conviction_search_result) { double(:conviction_search_result) }
        let(:key_person) { double(:key_person, conviction_search_result: conviction_search_result) }

        context "when key_person_has_matching_or_unknown_conviction? is true" do
          let(:key_person_has_matching_or_unknown_conviction) { true }

          it "returns true" do
            expect(subject.display_people_convictions?).to eq(true)
          end
        end

        context "when key_person_has_matching_or_unknown_conviction? is false" do
          let(:key_person_has_matching_or_unknown_conviction) { false }

          it "returns false" do
            expect(subject.display_people_convictions?).to eq(false)
          end
        end
      end
    end
  end

  describe "#approved_or_revoked?" do
    context "when conviction_check_approved? is true" do
      let(:conviction_check_approved) { true }

      it "returns true" do
        expect(subject.approved_or_revoked?).to eq(true)
      end
    end

    context "when conviction_check_approved? is false" do
      let(:conviction_check_approved) { false }

      context "when revoked? is true" do
        let(:revoked) { true }

        it "returns true" do
          expect(subject.approved_or_revoked?).to eq(true)
        end
      end

      context "when revoked? is false" do
        let(:revoked) { false }

        it "returns false" do
          expect(subject.approved_or_revoked?).to eq(false)
        end
      end
    end
  end

  describe "#people_with_matches" do
    context "when there are no key people" do
      let(:key_people) { [] }

      it "returns an empty array" do
        expect(subject.people_with_matches).to eq([])
      end
    end

    context "when there is a key person" do
      let(:key_people) { [key_person] }

      context "when a conviction check is not required" do
        let(:conviction_check_required) { false }

        it "returns an empty array" do
          expect(subject.people_with_matches).to eq([])
        end
      end

      context "when a conviction check is required" do
        let(:conviction_check_required) { true }

        it "includes the person in the array" do
          expect(subject.people_with_matches).to eq([key_person])
        end
      end
    end
  end

  describe "#relevant_people_without_matches" do
    context "when there are no relevant people" do
      let(:relevant_people) { [] }

      it "returns an empty array" do
        expect(subject.relevant_people_without_matches).to eq([])
      end
    end

    context "when there is a relevant person" do
      let(:relevant_people) { [key_person] }

      context "when a conviction check is not required for that person" do
        let(:conviction_check_required) { false }

        it "includes the person in the array" do
          expect(subject.relevant_people_without_matches).to eq([key_person])
        end
      end

      context "when a conviction check is required for that person" do
        let(:conviction_check_required) { true }

        it "returns an empty array" do
          expect(subject.relevant_people_without_matches).to eq([])
        end
      end
    end
  end
end
