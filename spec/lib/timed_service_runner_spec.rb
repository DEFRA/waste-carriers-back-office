# frozen_string_literal: true

require "rails_helper"
require_relative "../../lib/timed_service_runner"

RSpec.describe TimedServiceRunner do
  describe ".run" do
    let(:scope) { instance_double(Array) }
    let(:run_for) { 1 } # minute
    let(:service) { class_double(WasteCarriersEngine::AssignSiteDetailsService) }

    before do
      allow(scope).to receive(:each)
      allow(service).to receive(:run)
      allow(service).to receive(:name).and_return("AssignSiteDetailsService")
      allow(Time).to receive(:zone).and_return(ActiveSupport::TimeZone["UTC"])
    end

    it "stops processing when the run_until time is reached" do
      # Set the current time to be just before the run_until time
      current_time = run_for.minutes.from_now - 10.seconds
      allow(Time.zone).to receive(:now).and_return(current_time)

      described_class.run(scope: scope, run_for: run_for, service: service)

      expect(scope).to have_received(:each)
    end

    it "calls the service for each address in the scope" do
      addresses = [instance_double(WasteCarriersEngine::Address), instance_double(WasteCarriersEngine::Address)]

      allow(scope).to receive(:each).and_yield(addresses[0]).and_yield(addresses[1])

      addresses.each do |address|
        allow(service).to receive(:run).with(address: address)
        allow(address).to receive(:save!)
      end

      described_class.run(scope: scope, run_for: run_for, service: service)

      addresses.each do |address|
        expect(service).to have_received(:run).with(address: address)
        expect(address).to have_received(:save!)
      end
    end

    context "when an error occurs during service execution" do
      let(:address) { instance_double(WasteCarriersEngine::Address, id: 1) }

      before do
        allow(scope).to receive(:each).and_yield(address)
        allow(service).to receive(:run).and_raise(StandardError.new("Test error"))
        allow(address).to receive(:save!)
        allow(Airbrake).to receive(:notify)
        allow(Rails.logger).to receive(:error)
      end

      it "logs the error and notifies Airbrake" do
        described_class.run(scope: scope, run_for: run_for, service: service)

        expect(Airbrake).to have_received(:notify).with(instance_of(StandardError), address_id: address.id)
        expect(Rails.logger).to have_received(:error).with("AssignSiteDetailsService failed:\n Test error")
      end
    end
  end
end
