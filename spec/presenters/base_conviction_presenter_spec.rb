# frozen_string_literal: true

require "rails_helper"

RSpec.describe BaseConvictionPresenter do
  let(:conviction_sign_off) { double(:conviction_sign_off, workflow_state: "possible_match") }
  let(:conviction_sign_offs) { [conviction_sign_off] }

  let(:conviction_check_required) { false }
  let(:key_person) do
    double(:key_person,
           conviction_check_required?: conviction_check_required)
  end
  let(:key_people) { [key_person] }

  let(:conviction_check_approved) {}
  let(:revoked) {}

  let(:registration) do
    double(:registration,
           conviction_sign_offs: conviction_sign_offs,
           key_people: key_people,
           conviction_check_approved?: conviction_check_approved,
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
end
