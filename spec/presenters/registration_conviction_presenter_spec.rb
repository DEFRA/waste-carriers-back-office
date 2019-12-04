# frozen_string_literal: true

require "rails_helper"

RSpec.describe RegistrationConvictionPresenter do
  let(:registration) { double(:registration) }
  let(:view_context) { double(:view_context) }
  subject { described_class.new(registration, view_context) }

  describe "#display_actions?" do
    context "when conviction_check_required? is false" do
      before { expect(registration).to receive(:conviction_check_required?).and_return(false) }

      it "returns false" do
        expect(subject.display_actions?).to eq(false)
      end
    end

    context "when conviction_check_required? is true" do
      before { expect(registration).to receive(:conviction_check_required?).and_return(true) }

      it "returns true" do
        expect(subject.display_actions?).to eq(true)
      end
    end
  end
end
