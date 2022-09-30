# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewingRegistrationConvictionPresenter do
  subject { described_class.new(renewing_registration, view_context) }

  let(:reg_identifier) { "CBDU1" }
  let(:conviction_check_required) {}
  let(:renewal_application_submitted) {}
  let(:renewing_registration) do
    double(:renewing_registration,
           reg_identifier: reg_identifier,
           conviction_check_required?: conviction_check_required,
           renewal_application_submitted?: renewal_application_submitted)
  end
  let(:view_context) { double(:view_context) }

  describe "#display_actions?" do
    context "when renewal_application_submitted? is false" do
      let(:renewal_application_submitted) { false }

      it "returns false" do
        expect(subject.display_actions?).to be(false)
      end
    end

    context "when renewal_application_submitted? is true" do
      let(:renewal_application_submitted) { true }

      context "when conviction_check_required? is false" do
        let(:conviction_check_required) { false }

        it "returns false" do
          expect(subject.display_actions?).to be(false)
        end
      end

      context "when conviction_check_required? is true" do
        let(:conviction_check_required) { true }

        it "returns true" do
          expect(subject.display_actions?).to be(true)
        end
      end
    end
  end

  describe "#begin_checks_path" do
    it "returns the correct path" do
      expected_path = "/bo/transient-registrations/#{reg_identifier}/convictions/begin-checks"

      expect(subject.begin_checks_path).to eq(expected_path)
    end
  end

  describe "#approve_path" do
    it "returns the correct path" do
      expected_path = "/bo/transient-registrations/#{reg_identifier}/convictions/approve"

      expect(subject.approve_path).to eq(expected_path)
    end
  end

  describe "#reject_path" do
    it "returns the correct path" do
      expected_path = "/bo/transient-registrations/#{reg_identifier}/convictions/reject"

      expect(subject.reject_path).to eq(expected_path)
    end
  end
end
