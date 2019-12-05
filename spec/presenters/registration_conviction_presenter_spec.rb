# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationConvictionPresenter do
  let(:reg_identifier) { "CBDU1" }
  let(:conviction_check_required) {}
  let(:registration) do
    double(:registration,
           reg_identifier: reg_identifier,
           conviction_check_required?: conviction_check_required)
  end
  let(:view_context) { double(:view_context) }
  subject { described_class.new(registration, view_context) }

  describe "#display_actions?" do
    context "when conviction_check_required? is false" do
      let(:conviction_check_required) { false }

      it "returns false" do
        expect(subject.display_actions?).to eq(false)
      end
    end

    context "when conviction_check_required? is true" do
      let(:conviction_check_required) { true }

      it "returns true" do
        expect(subject.display_actions?).to eq(true)
      end
    end
  end

  describe "#begin_checks_path" do
    it "returns the correct path" do
      expected_path = "/bo/registrations/#{reg_identifier}/convictions/begin-checks"

      expect(subject.begin_checks_path).to eq(expected_path)
    end
  end

  describe "#approve_path" do
    it "returns the correct path" do
      expected_path = "/bo/registrations/#{reg_identifier}/convictions/approve"

      expect(subject.approve_path).to eq(expected_path)
    end
  end
end
