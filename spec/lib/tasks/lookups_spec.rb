# spec/tasks/lookups_rake_spec.rb
require 'rails_helper'
require 'rake'

RSpec.describe "lookups:update:missing_area" do
  before do
    Rails.application.load_tasks
    Rake::Task["lookups:update:missing_area"].reenable
  end

  after do
    Rake::Task.clear
  end

  it "updates the area field for a maximum of 50 addresses with missing area and a postcode" do
    # Create registrations with addresses that have a missing area and a postcode
    registrations = create_list(:registration, 55)
    registrations.each do |registration|
      create(:address, registration: registration, area: nil, postcode: "AB1 2CD")
    end

    # Expect TimedServiceRunner to be called with the correct amount of addresses
    expect(TimedServiceRunner).to receive(:run).with(
      scope: array_with_size(50, WasteCarriersEngine::Address),
      run_for: 60,
      service: WasteCarriersEngine::AssignSiteDetailsService
    ).at_least(:once)

    # Run the rake task
    Rake::Task["lookups:update:missing_area"].invoke
  end
end
