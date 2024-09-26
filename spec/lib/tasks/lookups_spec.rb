# frozen_string_literal: true

require "rails_helper"

# rubocop:disable RSpec/LetSetup
RSpec.describe "lookups:update:missing_address_attributes", type: :task do
  include_context "rake"

  let(:task) { Rake::Task["lookups:update:missing_address_attributes"] }

  before do
    allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:run_ea_areas_job).and_return(true)

    # To avoid creating excessive test data, we reduce the default 50 to 8.
    allow(WasteCarriersBackOffice::Application.config).to receive(:area_lookup_address_limit).and_return(8)

    allow(TimedServiceRunner).to receive(:run)

    task.reenable
  end

  shared_examples "includes the address" do
    let(:address_attributes) { registration.company_address.attributes.slice(:addresstype, :postcode, :addressLine1, :addressLine2) }

    before { task.invoke }

    it "includes an address with the expected attributes" do
      expect(TimedServiceRunner).to have_received(:run).with(
        scope: array_including(an_object_having_attributes(address_attributes)),
        run_for: WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i,
        service: WasteCarriersEngine::UpdateAddressDetailsFromOsPlacesService,
        throttle: 0.1
      )
    end
  end

  shared_examples "expected address scope" do |expected_address_count|

    before { task.invoke }

    it "calls the service with the expected array of addresses" do
      expect(TimedServiceRunner).to have_received(:run).with(
        scope: array_with_size(expected_address_count, WasteCarriersEngine::Address),
        run_for: WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i,
        service: WasteCarriersEngine::UpdateAddressDetailsFromOsPlacesService,
        throttle: 0.1
      )
    end
  end

  shared_examples "no addresses in scope" do
    it_behaves_like "expected address scope", 0
  end

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

  context "when the only registration is inactive" do
    before do
      create(:registration, :inactive, addresses: [build(:address, :registered, area: nil, postcode: "AB1 2CD")])
    end

    it_behaves_like "no addresses in scope"
  end

  context "when the postcode on the only registration is missing" do
    before do
      create(:registration, addresses: [build(:address, :registered, area: nil, postcode: nil)])
    end

    it_behaves_like "no addresses in scope"
  end

  context "when the area is nil" do
    let!(:registration) { create(:registration, addresses: [build(:address, :registered, area: nil, postcode: "AB1 2CD")]) }

    it_behaves_like "includes the address"
  end

  context "when the area is blank" do
    let!(:registration) { create(:registration, addresses: [build(:address, :registered, area: "", postcode: "AB1 2CD")]) }

    it_behaves_like "includes the address"
  end

  context "when the easting is nil" do
    let!(:registration) { create(:registration, addresses: [build(:address, :registered, area: "BRISTOL", postcode: "AB1 2CD", easting: nil)]) }

    it_behaves_like "includes the address"
  end

  context "when the northing is nil" do
    let!(:registration) { create(:registration, addresses: [build(:address, :registered, area: "BRISTOL", postcode: "AB1 2CD", northing: nil)]) }

    it_behaves_like "includes the address"
  end

  context "with greater than the maximum number of addresses with missing area and a postcode" do
    before do
      registrations = create_list(:registration, 10)
      registrations.each do |registration|
        create(:address, :registered, registration: registration, area: nil, postcode: "AB1 2CD")
      end
    end

    it_behaves_like "expected address scope", 8
  end
end
# rubocop:enable RSpec/LetSetup
