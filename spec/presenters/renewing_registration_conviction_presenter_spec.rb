# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewingRegistrationConvictionPresenter do
  let(:conviction_check_required) {}
  let(:renewal_application_submitted) {}
  let(:renewing_registration) do
    double(:renewing_registration,
           conviction_check_required?: conviction_check_required,
           renewal_application_submitted?: renewal_application_submitted)
  end
  let(:view_context) { double(:view_context) }
  subject { described_class.new(renewing_registration, view_context) }

  describe "#display_actions?" do
    context "when renewal_application_submitted? is false" do
      let(:renewal_application_submitted) { false }

      it "returns false" do
        expect(subject.display_actions?).to eq(false)
      end
    end

    context "when renewal_application_submitted? is true" do
      let(:renewal_application_submitted) { true }

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
  end
end
