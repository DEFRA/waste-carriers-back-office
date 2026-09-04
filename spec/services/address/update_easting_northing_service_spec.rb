# frozen_string_literal: true

require "rails_helper"

module Address
  RSpec.describe UpdateEastingNorthingService, type: :service do
    describe "#run" do
      let(:address) { build(:address, address_type: "REGISTERED", postcode:, easting:, northing:) }
      let(:registration) { create(:registration, addresses: [address]) }
      let(:postcode) { "BS1 5AH" }
      let(:address_data) { JSON.parse(file_fixture("address_lookup_response.json").read) }
      let(:valid_easting) { address_data["x"] }
      let(:valid_northing) { address_data["y"] }

      subject(:run_service) { described_class.run(registration_id: registration.id) }

      before do
        allow(WasteCarriersEngine::AddressLookupService).to receive(:run).and_return(
          instance_double(DefraRuby::Address::Response, successful?: true, results: [address_data])
        )
      end

      context "when the address has easting and northing values" do
        let(:easting) { valid_easting }
        let(:northing) { valid_northing }

        it { expect { run_service }.not_to change { registration.reload.registered_address.easting } }
        it { expect { run_service }.not_to change { registration.reload.registered_address.northing } }
      end

      context "when the address has an easting and no northing" do
        let(:easting) { valid_easting }
        let(:northing) { nil }

        it { expect { run_service }.not_to change { registration.reload.registered_address.easting } }
        it { expect { run_service }.to change { registration.reload.registered_address.northing } }
      end

      context "when the address has a northing and no easting" do
        let(:easting) { nil }
        let(:northing) { valid_northing }

        it { expect { run_service }.to change { registration.reload.registered_address.easting } }
        it { expect { run_service }.not_to change { registration.reload.registered_address.northing } }
      end

      context "when the address has no easting or northing values" do
        let(:easting) { nil }
        let(:northing) { nil }

        it { expect { run_service }.to change { registration.reload.registered_address.easting } }
        it { expect { run_service }.to change { registration.reload.registered_address.northing } }

        context "when the address does not have a postcode" do
          let(:postcode) { nil }

          it { expect { run_service }.not_to change { registration.reload.registered_address.easting } }
          it { expect { run_service }.not_to change { registration.reload.registered_address.northing } }
        end
      end
    end
  end
end
