# frozen_string_literal: true

require "rails_helper"

RSpec.describe "lookups:update" do

  before do
    allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:run_ea_areas_job).and_return(true)

    allow(TimedServiceRunner).to receive(:run)

    # To avoid creating excessive test data, we reduce the default 50 to 8.
    allow(WasteCarriersBackOffice::Application.config).to receive(:lookups_update_address_limit).and_return(8)

    task.reenable
  end

  RSpec.shared_examples "includes the address" do
    let(:address_attributes) { registration.registered_address.attributes.slice(:addresstype, :postcode, :addressLine1, :addressLine2) }

    before { task.invoke }

    it "includes an address with the expected attributes" do
      expect(TimedServiceRunner).to have_received(:run).with(
        scope: array_including(registration.id),
        run_for: WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i,
        service: update_service,
        throttle: 0.1
      )
    end
  end

  RSpec.shared_examples "inactive registration" do
    before do
      create(:registration, :inactive, addresses: [build(:address, :registered, area: nil, postcode: "AB1 2CD")])

      task.invoke
    end

    it_behaves_like "no addresses in scope"
  end

  RSpec.shared_examples "missing postcode" do
    before do
      create(:registration, addresses: [build(:address, :registered, area: nil, postcode: nil)])

      task.invoke
    end

    it_behaves_like "no addresses in scope"
  end

  RSpec.shared_examples "excludes overseas addresses" do
    let(:address_attributes) { registration.registered_address.attributes.slice(:addresstype, :postcode, :addressLine1, :addressLine2) }

    before do
      create(:registration, location: "overseas", addresses: [build(:address, :registered, area: nil)])
      # create(:registration, addresses: [build(:address, :registered, area: nil)])

      task.invoke
    end

    it_behaves_like "no addresses in scope"
  end

  RSpec.shared_examples "expected address scope" do |expected_registration_count|

    before { task.invoke }

    it "calls the service with the expected number of registrations" do
      expect(TimedServiceRunner).to have_received(:run).with(
        scope: array_with_size(expected_registration_count, WasteCarriersEngine::Address),
        run_for: WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i,
        service: update_service,
        throttle: 0.1
      )
    end
  end

  RSpec.shared_examples "limits the number of addresses" do
    before do
      registrations = create_list(:registration, 10)
      registrations.each do |registration|
        create(:address, :registered, registration: registration, area: nil, easting: nil, postcode: "AB1 2CD")
      end

      task.invoke
    end

    it_behaves_like "expected address scope", 8
  end

  RSpec.shared_examples "no addresses in scope" do
    it { expect(TimedServiceRunner).not_to have_received(:run) }
  end

  # rubocop:disable RSpec/LetSetup
  describe "missing_ea_areas", type: :task do
    let(:task) { Rake::Task["lookups:update:missing_ea_areas"] }
    let(:update_service) { Address::UpdateEaAreaService }

    it_behaves_like "inactive registration"

    it_behaves_like "missing postcode"

    context "when the area is present" do
      before do
        create(:registration, addresses: [build(:address, :registered, area: "Test Area", postcode: "AB1 2CD")])
      end

      it_behaves_like "no addresses in scope"
    end

    context "when the contact address area is blank and the registered address area is present" do
      before do
        create(:registration, addresses: [
                 build(:address, :contact, area: nil, postcode: nil),
                 build(:address, :registered, area: "BRISTOL", postcode: "AB1 2CD")
               ])
      end

      it_behaves_like "no addresses in scope"
    end

    context "when the area is nil" do
      let!(:registration) { create(:registration, addresses: [build(:address, :registered, area: nil, postcode: "AB1 2CD")]) }

      it_behaves_like "includes the address"
    end

    # Tests for shared area / easting-northing selection logic:

    context "when easting and northing are present" do
      let!(:registration) { create(:registration, addresses: [build(:address, :registered, area: nil, easting: 358_205, northing: 172_708, postcode: "AB1 2CD")]) }

      it_behaves_like "includes the address"
    end

    context "when the area is blank" do
      let!(:registration) { create(:registration, addresses: [build(:address, :registered, area: "", postcode: "AB1 2CD")]) }

      it_behaves_like "includes the address"
    end

    it_behaves_like "limits the number of addresses"

    it_behaves_like "excludes overseas addresses"
  end

  describe "missing_easting_northings", type: :task do
    let(:task) { Rake::Task["lookups:update:missing_easting_northings"] }
    let(:update_service) { Address::UpdateEastingNorthingService }

    it_behaves_like "inactive registration"

    it_behaves_like "missing postcode"

    context "with an active registration" do
      let(:easting) { nil }
      let(:northing) { nil }
      let(:area) { nil }
      let!(:registration) { create(:registration, addresses: [build(:address, :registered, area:, postcode: "AB1 2CD", easting:, northing:)]) }

      context "when easting and northing are present" do
        let(:easting) { 358_205 }
        let(:northing) { 172_708 }

        it_behaves_like "no addresses in scope"
      end

      context "when only easting is present" do
        let(:easting) { 358_205 }

        it_behaves_like "includes the address"
      end

      context "when only northing is present" do
        let(:northing) { 172_708 }

        it_behaves_like "includes the address"
      end

      context "when easting and northing are nil" do
        let(:easting) { nil }
        let(:northing) { nil }

        it_behaves_like "includes the address"

        # check shared area / easting-northing selection logic
        context "when area is present" do
          let(:area) { "BRISTOL" }

          it_behaves_like "includes the address"
        end
      end
    end

    it_behaves_like "limits the number of addresses"

    it_behaves_like "excludes overseas addresses"
  end
  # rubocop:enable RSpec/LetSetup
end
