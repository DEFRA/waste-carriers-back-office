# frozen_string_literal: true

require "rails_helper"

RSpec.describe BaseConvictionPresenter do
  let(:conviction_sign_off) { double(:conviction_sign_off, workflow_state: "possible_match") }
  let(:conviction_sign_offs) { [conviction_sign_off] }
  let(:registration) do
    double(:registration,
           conviction_sign_offs: conviction_sign_offs)
  end

  let(:view_context) { double(:view_context) }
  subject { described_class.new(registration, view_context) }

  describe "#conviction_status_message" do
    context "when a conviction_sign_off is present" do
      it "returns the correct message" do
        message = "This renewal may have matching or declared convictions and requires an initial review."

        expect(subject.conviction_status_message).to eq(message)
      end
    end

    context "when a conviction_sign_off is not present" do
      let(:conviction_sign_offs) { [] }

      it "returns the correct message" do
        message = "This renewal does not require a conviction check before it can be approved."

        expect(subject.conviction_status_message).to eq(message)
      end
    end
  end
end
