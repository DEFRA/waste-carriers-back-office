# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe FlowPermissionChecksService do
    describe ".run" do
      let(:user) { instance_double(User) }
      let(:params) { { transient_registration: transient_registration, user: user } }
      let(:result) { instance_double(PermissionChecksResult) }

      before do
        allow(BlankPermissionCheckService).to receive(:run).and_return(result)
        allow(RenewingRegistrationPermissionChecksService).to receive(:run).and_return(result)
      end

      context "when the transient object is a renewing registration" do
        let(:transient_registration) { RenewingRegistration.new }

        it "runs the correct permission check service and return a result" do
          expect(described_class.run(params)).to eq(result)

          expect(RenewingRegistrationPermissionChecksService).to have_received(:run).with(params)
        end
      end

      context "when the transient object is a new registration" do
        let(:transient_registration) { NewRegistration.new }

        it "runs the correct permission check service and return a result" do
          expect(described_class.run(params)).to eq(result)

          expect(BlankPermissionCheckService).to have_received(:run).with(params)
        end
      end

      context "when the transient object is a dergistering registration" do
        let(:transient_registration) { DeregisteringRegistration.new }

        it "runs the correct permission check service and return a result" do
          expect(described_class.run(params)).to eq(result)

          expect(BlankPermissionCheckService).to have_received(:run).with(params)
        end
      end

      context "when there is no permission check service for the given transient object" do
        let(:transient_registration) { instance_double(TransientRegistration) }

        it "raises a specific error" do
          expect { described_class.run(params) }.to raise_error(FlowPermissionChecksService::MissingFlowPermissionChecksService)
        end
      end
    end
  end
end
