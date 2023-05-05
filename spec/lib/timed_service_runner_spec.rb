require 'rails_helper'
require_relative '../../lib/timed_service_runner'

RSpec.describe TimedServiceRunner do
  describe '.run' do
    let(:scope) { double('scope') }
    let(:run_for) { 1 } # minute
    let(:service) { class_double(WasteCarriersEngine::AssignSiteDetailsService) }

    before do
      allow(scope).to receive(:each)
      allow(service).to receive(:run)
      allow(service).to receive(:name).and_return('AssignSiteDetailsService')
      allow(Time).to receive(:zone).and_return(ActiveSupport::TimeZone['UTC'])
    end

    it 'stops processing when the run_until time is reached' do
      # Set the current time to be just before the run_until time
      current_time = run_for.minutes.from_now - 10.seconds
      allow(Time.zone).to receive(:now).and_return(current_time)

      expect(scope).to receive(:each)

      TimedServiceRunner.run(scope: scope, run_for: run_for, service: service)
    end

    it 'calls the service for each address in the scope' do
      addresses = [double('address1'), double('address2')]

      allow(scope).to receive(:each).and_yield(addresses[0]).and_yield(addresses[1])

      addresses.each do |address|
        expect(service).to receive(:run).with(address: address)
        expect(address).to receive(:save!)
      end

      TimedServiceRunner.run(scope: scope, run_for: run_for, service: service)
    end

    context 'when an error occurs during service execution' do
      let(:address) { double('address', id: 1) }

      before do
        allow(scope).to receive(:each).and_yield(address)
        allow(service).to receive(:run).and_raise(StandardError.new('Test error'))
        allow(address).to receive(:save!)
      end

      it 'logs the error and notifies Airbrake' do
        expect(Airbrake).to receive(:notify).with(instance_of(StandardError), address_id: address.id)
        expect(Rails.logger).to receive(:error).with("AssignSiteDetailsService failed:\n Test error")

        TimedServiceRunner.run(scope: scope, run_for: run_for, service: service)
      end
    end
  end
end
