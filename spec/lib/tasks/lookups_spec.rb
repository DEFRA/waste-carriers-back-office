# frozen_string_literal: true

# spec/tasks/lookups_rake_spec.rb
require "rails_helper"

RSpec.describe "lookups:update:missing_area", type: :rake do
  include_context "rake"
  let(:task) { Rake::Task["lookups:update:missing_area"] }

  before do
    allow(WasteCarriersEngine::FeatureToggle).to receive(:active?).with(:run_ea_areas_job).and_return(true)
    task.reenable
  end

  it "updates the area field for a maximum of 50 addresses with missing area and a postcode" do
    registrations = create_list(:registration, 55)
    registrations.each do |registration|
      create(:address, :registered, registration: registration, area: nil, postcode: "AB1 2CD")
    end

    allow(TimedServiceRunner).to receive(:run)

    task.invoke

    expect(TimedServiceRunner).to have_received(:run).with(
      scope: array_with_size(50, WasteCarriersEngine::Address),
      run_for: WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i,
      service: WasteCarriersEngine::AssignSiteDetailsService,
      throttle: 0.1
    ).at_least(:once)
  end

  context "when the company address is blank" do
    it "does not include the address in the service call" do
      create(:registration, addresses: [build(:address, :contact)])

      allow(TimedServiceRunner).to receive(:run)

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
      create(:registration, :inactive, addresses: [build(:address, :registered, postcode: "AB1 2CD")])

      allow(TimedServiceRunner).to receive(:run)

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
      create(:registration, addresses: [build(:address, :registered, postcode: nil)])

      allow(TimedServiceRunner).to receive(:run)

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

      allow(TimedServiceRunner).to receive(:run)

      task.invoke

      expect(TimedServiceRunner).to have_received(:run).with(
        scope: [],
        run_for: WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i,
        service: WasteCarriersEngine::AssignSiteDetailsService,
        throttle: 0.1
      ).at_least(:once)
    end
  end

  context "when the correct attributes are passed in" do
    it "calls the TimedServiceRunner with the correct attributes" do
      registration = create(:registration, addresses: [build(:address, :registered, area: nil, postcode: "AB1 2CD")])

      address_attributes = registration.company_address.attributes.slice(:addresstype, :postcode, :addressLine1, :addressLine2)

      allow(TimedServiceRunner).to receive(:run)

      task.invoke

      expect(TimedServiceRunner).to have_received(:run).with(
        scope: array_including(an_object_having_attributes(address_attributes)),
        run_for: WasteCarriersBackOffice::Application.config.area_lookup_run_for.to_i,
        service: WasteCarriersEngine::AssignSiteDetailsService,
        throttle: 0.1
      ).at_least(:once)
    end
  end
end
