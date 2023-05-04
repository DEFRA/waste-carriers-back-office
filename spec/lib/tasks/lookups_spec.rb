# frozen_string_literal: true

# spec/tasks/lookups_rake_spec.rb
require "rails_helper"

RSpec.describe "lookups:update:missing_area", type: :rake do
  include_context "rake"

  it "updates the area field for a maximum of 50 addresses with missing area and a postcode" do
    # Create registrations with addresses that have a missing area and a postcode
    registrations = create_list(:registration, 55)
    registrations.each do |registration|
      create(:address, registration: registration, area: nil, postcode: "AB1 2CD")
    end

    # Set up TimedServiceRunner as a spy
    allow(TimedServiceRunner).to receive(:run)

    # Run the rake task
    Rake::Task["lookups:update:missing_area"].invoke

    # Expect TimedServiceRunner to be called with the correct amount of addresses
    expect(TimedServiceRunner).to have_received(:run).with(
      scope: array_with_size(50, WasteCarriersEngine::Address),
      run_for: 60,
      service: WasteCarriersEngine::AssignSiteDetailsService
    ).at_least(:once)
  end
end
