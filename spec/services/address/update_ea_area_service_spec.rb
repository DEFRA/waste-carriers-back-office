# frozen_string_literal: true

require "rails_helper"
require "defra_ruby/area"

module Address
  RSpec.describe UpdateEaAreaService, type: :service do
    describe "#run" do
      let(:easting) { 123_456 }
      let(:northing) { 654_321 }
      let(:area) { "Area Name" }
      let(:postcode) { "BS1 5AH" }
      let(:registration) { create(:registration, addresses: [address]) }

      subject(:run_service) { described_class.run(registration_id: registration.id) }

      before do
        allow(Geographic::MapPostcodeToEastingAndNorthingService).to receive(:run).and_return(easting:, northing:)
      end

      shared_examples "updates the area" do
        it { expect { run_service }.to change { registration.reload.registered_address.area }.to(area) }
      end

      shared_examples "does not update the area" do
        it { expect { run_service }.not_to change { registration.reload.registered_address.area } }
      end

      context "when the address has a postcode and area is not present" do
        let(:address) { build(:address, address_type: "REGISTERED", postcode:, area: nil) }

        context "when the determine area service returns an area" do
          before { allow(Geographic::MapEastingAndNorthingToEaAreaService).to receive(:run).and_return("Area Name") }

          it_behaves_like "updates the area"
        end

        context "when the determine area service does not return an area" do
          before { allow(Geographic::MapEastingAndNorthingToEaAreaService).to receive(:run).and_return(nil) }

          it_behaves_like "does not update the area"
        end

        context "when the easting and northing values are nil" do
          let(:easting) { nil }
          let(:northing) { nil }
          let(:area_service) { instance_double(DefraRuby::Area::PublicFaceAreaService) }

          before do
            allow(DefraRuby::Area::PublicFaceAreaService).to receive(:new).and_return(area_service)
            allow(area_service).to receive(:run).and_raise(StandardError.new("Bad request"))
          end

          it "does not call the area service" do
            run_service

            expect(area_service).not_to have_received(:run)
          end
        end
      end

      context "when the address has an area" do
        let(:address) { build(:address, address_type: "REGISTERED", area:) }

        it_behaves_like "does not update the area"
      end

      context "when the address does not have a postcode" do
        let(:address) { build(:address, address_type: "REGISTERED", postcode: nil) }

        it_behaves_like "does not update the area"
      end

      context "when address has an overseas registration" do
        let(:address) { build(:address, address_type: "REGISTERED", postcode:, area: nil) }
        let(:registration) { create(:registration, addresses: [address], location: "overseas") }

        it { expect { run_service }.to change { registration.reload.registered_address.area }.to("Outside England") }
      end
    end
  end
end
