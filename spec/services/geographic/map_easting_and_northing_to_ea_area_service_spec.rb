# frozen_string_literal: true

require "rails_helper"

module Geographic
  RSpec.describe MapEastingAndNorthingToEaAreaService do
    describe ".run" do
      let(:coordinates) { { easting: 358_205.03, northing: 172_708.07 } }
      let(:result) { nil }

      before do
        allow(WasteCarriersEngine::DetermineEaAreaService)
          .to receive(:run)
          .with(easting: coordinates[:easting], northing: coordinates[:northing])
          .and_return(result)
      end

      context "when an area contains the point" do
        let(:result) { "Wessex" }

        it "returns the matching area" do
          expect(described_class.run(coordinates)).to eq "Wessex"
        end

        it "does not notify Airbrake of an error" do
          allow(Airbrake).to receive(:notify)

          described_class.run(coordinates)

          expect(Airbrake).not_to have_received(:notify)
        end
      end

      context "when no area contains the point" do
        let(:result) { "Outside England" }

        it "returns 'Outside England'" do
          expect(described_class.run(coordinates)).to eq "Outside England"
        end
      end

      context "when the coordinates are invalid" do
        let(:result) { nil }

        it "returns nil" do
          expect(described_class.run(coordinates)).to be_nil
        end
      end

      context "when the lookup raises an error" do
        before do
          allow(WasteCarriersEngine::DetermineEaAreaService)
            .to receive(:run)
            .and_raise(StandardError.new("lookup failed"))
        end

        it "returns nil" do
          expect(described_class.run(coordinates)).to be_nil
        end

        it "uses Airbrake to notify Errbit of the error" do
          allow(Airbrake).to receive(:notify)

          described_class.run(coordinates)

          expect(Airbrake).to have_received(:notify)
        end
      end
    end
  end
end
