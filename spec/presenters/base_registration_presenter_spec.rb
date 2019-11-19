# frozen_string_literal: true

RSpec.describe BaseRegistrationPresenter do
  let(:registration) { double(:registration) }
  let(:view_context) { double(:view_context) }
  subject { described_class.new(registration, view_context) }

  describe "#displayable_location" do
    let(:registration) { double(:registration, location: location) }

    context "when there is no location value" do
      let(:location) { nil }

      it "displays a placeholder" do
        expect(subject.displayable_location).to eq("Place of business: –")
      end
    end

    context "when there is a location value" do
      let(:location) { "england" }

      it "displays the location value" do
        expect(subject.displayable_location).to eq("Place of business: England")
      end
    end
  end

  describe "#display_convictions_check_message" do
    context "when the registration is a lower tier registration" do
      let(:registration) { double(:registration, lower_tier?: true) }

      it "returns the lower tier text" do
        message = "Lower tier registration - convictions are not applicable"

        expect(subject.display_convictions_check_message).to eq(message)
      end
    end

    context "when the registration has convictions checks approved" do
      let(:registration) { double(:registration, conviction_check_approved?: true, lower_tier?: false) }

      it "returns the convictions checks approved message" do
        message = "This registration was approved after a review of the matching or declared convictions."

        expect(subject.display_convictions_check_message).to eq(message)
      end
    end

    context "when the registration has convictions checks rejected" do
      let(:registration) do
        double(
          :registration,
          conviction_check_approved?: false,
          lower_tier?: false,
          rejected_conviction_checks?: true
        )
      end

      it "returns the convictions checks rejected message" do
        message = "This registration was rejected after a review of the matching or declared convictions."

        expect(subject.display_convictions_check_message).to eq(message)
      end
    end

    context "when the registration has convictions checks results" do
      let(:registration) do
        double(
          :registration,
          conviction_check_approved?: false,
          lower_tier?: false,
          rejected_conviction_checks?: false,
          conviction_search_result: double(:conviction_search_result),
          conviction_check_required?: conviction_check_required
        )
      end

      context "when a convictions check is required" do
        let(:conviction_check_required) { true }

        it "returns the convictions checks required message" do
          message = "This registration has matching or declared convictions."

          expect(subject.display_convictions_check_message).to eq(message)
        end
      end

      context "when a convictions check is not required" do
        let(:conviction_check_required) { false }

        it "returns the convictions checks not required message" do
          message = "There are no convictions for this registration."

          expect(subject.display_convictions_check_message).to eq(message)
        end
      end

      context "when we are unable to determine the status of convictions checks" do
        let(:registration) do
          double(
            :registration,
            conviction_check_approved?: false,
            lower_tier?: false,
            rejected_conviction_checks?: false,
            conviction_search_result: nil
          )
        end

        it "returns an unknown message" do
          message = "This registration application is still in progress, so there is no conviction match data yet."

          expect(subject.display_convictions_check_message).to eq(message)
        end
      end
    end
  end
end
