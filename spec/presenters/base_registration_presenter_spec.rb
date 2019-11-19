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
end
