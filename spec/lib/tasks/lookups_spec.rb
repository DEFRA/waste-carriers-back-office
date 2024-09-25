# frozen_string_literal: true

# spec/tasks/lookups_rake_spec.rb
require "rails_helper"

RSpec.describe "lookups:update:missing_area", type: :task do
  include_context "rake"
  let(:task) { Rake::Task["lookups:update:missing_area"] }

  before do
    allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:run_ea_areas_job).and_return(true)

    # To avoid creating excessive test data, we reduce the default 50 to 8.
    allow(WasteCarriersBackOffice::Application.config).to receive(:area_lookup_address_limit).and_return(8)

    allow(TimedServiceRunner).to receive(:run)

    task.reenable
  end

  it "updates the area field for a maximum of 8 addresses with missing area and a postcode" do
    registrations = create_list(:registration, 10)
    registrations.each do |registration|
      create(:address, :registered, registration: registration, area: nil, postcode: "AB1 2CD")
    end

    task.invoke

    expect(TimedServiceRunner).to have_received(:run).with(
      scope: array_with_size(8, WasteCarriersEngine::Address),
      run_for: WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i,
      service: WasteCarriersEngine::AssignSiteDetailsService,
      throttle: 0.1
    ).at_least(:once)
  end

  context "when the contact address area is blank" do
    it "does not include the contact address in the service call" do
      create(:registration, addresses: [build(:address, :contact, area: nil, postcode: "AB1 2CD")])

      task.invoke

      expect(TimedServiceRunner).to have_received(:run).with(
        scope: [],
        run_for: WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i,
        service: WasteCarriersEngine::AssignSiteDetailsService,
        throttle: 0.1
      ).at_least(:once)
    end
  end

  context "when a registration is inactive" do
    it "does not include the address in the service call" do
      create(:registration, :inactive, addresses: [build(:address, :registered, area: nil, postcode: "AB1 2CD")])

      task.invoke

      expect(TimedServiceRunner).to have_received(:run).with(
        scope: [],
        run_for: WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i,
        service: WasteCarriersEngine::AssignSiteDetailsService,
        throttle: 0.1
      ).at_least(:once)
    end
  end

  context "when the postcode is blank" do
    it "does not include the address in the service call" do
      create(:registration, addresses: [build(:address, :registered, area: nil, postcode: nil)])

      task.invoke

      expect(TimedServiceRunner).to have_received(:run).with(
        scope: [],
        run_for: WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i,
        service: WasteCarriersEngine::AssignSiteDetailsService,
        throttle: 0.1
      ).at_least(:once)
    end
  end

  context "when the area is present" do
    it "does not include the address in the service call" do
      create(:registration, addresses: [build(:address, :registered, area: "Test Area", postcode: "AB1 2CD")])

      task.invoke

      expect(TimedServiceRunner).to have_received(:run).with(
        scope: [],
        run_for: WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i,
        service: WasteCarriersEngine::AssignSiteDetailsService,
        throttle: 0.1
      ).at_least(:once)
    end
  end

  shared_examples "includes the address" do
    let(:address_attributes) { registration.company_address.attributes.slice(:addresstype, :postcode, :addressLine1, :addressLine2) }

    it "calls the TimedServiceRunner with the correct address attributes" do

      task.invoke

      expect(TimedServiceRunner).to have_received(:run).with(
        scope: array_including(an_object_having_attributes(address_attributes)),
        run_for: WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i,
        service: WasteCarriersEngine::AssignSiteDetailsService,
        throttle: 0.1
      ).at_least(:once)
    end
  end

  context "when the area is nil" do
    # rubocop:disable RSpec/LetSetup
    let!(:registration) { create(:registration, addresses: [build(:address, :registered, area: nil, postcode: "AB1 2CD")]) }
    # rubocop:enable RSpec/LetSetup

    it_behaves_like "includes the address"
  end

  context "when the area is blank" do
    # rubocop:disable RSpec/LetSetup
    let!(:registration) { create(:registration, addresses: [build(:address, :registered, area: "", postcode: "AB1 2CD")]) }
    # rubocop:enable RSpec/LetSetup

    it_behaves_like "includes the address"
  end
end
