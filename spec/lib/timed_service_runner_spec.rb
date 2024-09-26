# frozen_string_literal: true

require "rails_helper"
require_relative "../../lib/timed_service_runner"

RSpec.describe TimedServiceRunner do
  describe ".run" do
    let(:run_for) { 1 } # minute
    let(:service) { class_double(WasteCarriersEngine::UpdateAddressDetailsFromOsPlacesService) }
    let(:registrations) { create_list(:registration, 2) }
    let(:scope) { registrations.pluck(:_id) }

    before do
      registrations.each do |registration|
        allow(service).to receive(:run).with(registration_id: registration.id)
      end
      allow(service).to receive(:name).and_return("UpdateAddressDetailsFromOsPlacesService")
      allow(Time).to receive(:zone).and_return(ActiveSupport::TimeZone["UTC"])
    end

    context "when the service runs successfully" do

      it "stops processing when the run_until time is reached" do
        # Set the current time to be just before the run_until time
        current_time = run_for.minutes.from_now - 10.seconds
        allow(Time.zone).to receive(:now).and_return(current_time)

        described_class.run(scope: scope, run_for: run_for, service: service)

        registrations.each do |registration|
          expect(service).to have_received(:run).with(registration_id: registration.id)
        end
      end

      it "calls the service for each address in the scope" do

        described_class.run(scope: scope, run_for: run_for, service: service)

        registrations.each do |registration|
          expect(service).to have_received(:run).with(registration_id: registration.id)
        end
      end
    end

    context "when an error occurs during service execution" do

      before do
        allow(service).to receive(:run).and_raise(StandardError.new("Test error"))
        allow(Airbrake).to receive(:notify)
        allow(Rails.logger).to receive(:error)
      end

      it "logs the error and notifies Airbrake" do
        described_class.run(scope: scope, run_for: run_for, service: service)

        expect(Airbrake).to have_received(:notify).with(instance_of(StandardError), registration_id: registrations[0].id)
        expect(Rails.logger).to have_received(:error).at_least(:once).with("UpdateAddressDetailsFromOsPlacesService failed:\n Test error")
      end
    end
  end
end
