# frozen_string_literal: true

require "rails_helper"
require "defra_ruby/area"

module Geographic
  RSpec.describe MapEastingAndNorthingToEaAreaService do
    describe ".run" do
      let(:coordinates) { { easting: 358_205.03, northing: 172_708.07 } }

      before do
        allow(DefraRuby::Area::PublicFaceAreaService)
          .to receive(:run)
          .with(coordinates[:easting], coordinates[:northing])
          .and_return(response)
      end

      context "when the lookup is successful" do
        let(:response) do
          instance_double(DefraRuby::Area::Response, successful?: true, areas: [instance_double(DefraRuby::Area::Area, long_name: "Wessex")])
        end

        it "returns the matching area" do
          expect(described_class.run(coordinates)).to eq "Wessex"
        end

        it "does not notify Airbrake of the error" do
          allow(Airbrake).to receive(:notify)

          described_class.run(coordinates)

          expect(Airbrake).not_to have_received(:notify)
        end
      end

      context "when the lookup is unsuccessful" do
        context "with no match found" do
          let(:response) { instance_double(DefraRuby::Area::Response, successful?: false, error: DefraRuby::Area::NoMatchError.new) }

          it "returns 'Outside England'" do
            expect(described_class.run(coordinates)).to eq "Outside England"
          end
        end

        context "with a failure" do
          let(:response) { instance_double(DefraRuby::Area::Response, successful?: false, error: StandardError.new) }

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
end
