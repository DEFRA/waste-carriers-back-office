# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe EditRegistrationPermissionChecksService do
    let(:transient_registration) { instance_double(EditRegistration) }
    let(:user) { instance_double(User) }
    let(:result) { instance_double(PermissionChecksResult) }
    let(:params) { { transient_registration: transient_registration, user: user } }

    describe ".run" do
      before do
        allow(result).to receive(:invalid!)
        allow(result).to receive(:pass!)
        allow(result).to receive(:needs_permissions!)
        allow(transient_registration).to receive(:valid?).and_return(valid)
        allow(PermissionChecksResult).to receive(:new).and_return(result)
      end

      context "when the transient registration is not valid" do
        let(:valid) { false }

        it "returns an invalid result" do
          expect(described_class.run(params)).to eq(result)

          expect(result).to have_received(:invalid!)
        end
      end

      context "when the transient registration is valid" do
        let(:valid) { true }
        let(:registration) { instance_double(EditRegistration) }
        let(:ability) { instance_double(Ability) }

        before do
          allow(transient_registration).to receive(:registration).and_return(registration)

          allow(Ability).to receive(:new).with(user).and_return(ability)
          allow(ability).to receive(:can?).with(:edit, registration).and_return(can)
        end

        context "when the user does not have the correct permissions" do
          let(:can) { false }

          it "returns a missing permissions result" do
            expect(described_class.run(params)).to eq(result)

            expect(result).to have_received(:needs_permissions!)
          end
        end

        context "when the user has the correct permissions" do
          let(:can) { true }
          let(:registration) { instance_double(EditRegistration) }

          before do
            allow(transient_registration).to receive(:registration).and_return(registration)
            allow(registration).to receive(:active?).and_return(active)
          end

          context "when the registration is not active" do
            let(:active) { false }

            it "returns an invalid result" do
              expect(described_class.run(params)).to eq(result)

              expect(result).to have_received(:invalid!)
            end
          end

          context "when the registration is active" do
            let(:active) { true }

            it "returns a pass result" do
              expect(described_class.run(params)).to eq(result)

              expect(result).to have_received(:pass!)
            end
          end
        end
      end
    end
  end
end