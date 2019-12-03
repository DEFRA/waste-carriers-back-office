# frozen_string_literal: true

require "rails_helper"

RSpec.describe RenewingRegistrationConvictionPresenter do
  let(:renewing_registration) { double(:renewing_registration) }
  let(:view_context) { double(:view_context) }
  subject { described_class.new(renewing_registration, view_context) }

  describe "#display_actions?" do
    context "when renewal_application_submitted? is false" do
      before { expect(renewing_registration).to receive(:renewal_application_submitted?).and_return(false) }

      it "returns false" do
        expect(subject.display_actions?).to eq(false)
      end
    end

    context "when renewal_application_submitted? is true" do
      before { expect(renewing_registration).to receive(:renewal_application_submitted?).and_return(true) }

      context "when conviction_check_required? is false" do
        before { expect(renewing_registration).to receive(:conviction_check_required?).and_return(false) }

        it "returns false" do
          expect(subject.display_actions?).to eq(false)
        end
      end

      context "when conviction_check_required? is true" do
        before { expect(renewing_registration).to receive(:conviction_check_required?).and_return(true) }

        it "returns true" do
          expect(subject.display_actions?).to eq(true)
        end
      end
    end
  end
end
