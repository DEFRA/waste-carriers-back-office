# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe RenewingRegistrationPermissionChecksService do

    before do
      allow(transient_registration).to receive(:valid?).and_return(valid)
      allow(PermissionChecksResult).to receive(:new).and_return(result)
    end

    describe ".run" do
      let(:transient_registration) { instance_double(RenewingRegistration, from_magic_link: false) }
      let(:user) { instance_double(User) }
      let(:result) { instance_double(PermissionChecksResult) }
      let(:params) { { transient_registration: transient_registration, user: user } }

      before do
        allow(result).to receive(:invalid!)
        allow(result).to receive(:needs_permissions!)
        allow(result).to receive(:pass!)
        allow(result).to receive(:unrenewable!)
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
        let(:registration) { instance_double(Registration) }
        let(:ability) { instance_double(Ability) }

        before do
          allow(transient_registration).to receive(:registration).and_return(registration)

          allow(Ability).to receive(:new).with(user).and_return(ability)
          allow(ability).to receive(:can?).with(:update, transient_registration).and_return(can)
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
          let(:registration) { instance_double(Registration) }

          before do
            allow(transient_registration).to receive_messages(registration: registration, can_be_renewed?: renewable)
          end

          context "when the transient_registration cannot be renewed" do
            let(:renewable) { false }

            it "returns an unrenewable result" do
              expect(described_class.run(params)).to eq(result)

              expect(result).to have_received(:unrenewable!)
            end
          end

          context "when the transient_registration is renewable" do
            let(:renewable) { true }

            context "when the transient registration is accessed through a magic link" do
              let(:transient_registration) { instance_double(RenewingRegistration, from_magic_link: true) }

              it "returns a pass result" do
                expect(described_class.run(params)).to eq(result)

                expect(result).to have_received(:pass!)
              end
            end

            it "returns a pass result" do
              expect(described_class.run(params)).to eq(result)

              expect(result).to have_received(:pass!)
            end
          end
        end
      end

      describe "temporary additional debugging" do
        let(:valid) { true }
        let(:registration) { create(:registration) }
        let(:transient_registration) do
          create(:renewing_registration, reg_identifier: registration.reg_identifier, from_magic_link: false)
        end
        let(:user) { nil }

        before do
          allow(Airbrake).to receive(:notify)
          allow(FeatureToggle).to receive(:active?).with(:additional_debug_logging).and_return true
        end

        it "logs an error" do
          described_class.run(params)

          expect(Airbrake).to have_received(:notify)
        end
      end
    end
  end
end
