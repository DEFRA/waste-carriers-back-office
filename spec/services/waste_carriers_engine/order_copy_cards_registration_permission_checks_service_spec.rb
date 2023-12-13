# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe OrderCopyCardsRegistrationPermissionChecksService do
    let(:transient_registration) { double(:transient_registration) }
    let(:user) { double(:user) }
    let(:result) { double(:result) }
    let(:params) { { transient_registration: transient_registration, user: user } }

    describe ".run" do
      before do
        allow(PermissionChecksResult).to receive(:new).and_return(result)
        allow(result).to receive(:invalid!)
        allow(result).to receive(:needs_permissions!)
        allow(result).to receive(:pass!)
        allow(transient_registration).to receive(:valid?).and_return(valid)
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
        let(:registration) { double(:registration) }
        let(:ability) { double(:ability) }

        before do
          allow(transient_registration).to receive(:registration).and_return(registration)

          allow(Ability).to receive(:new).with(user).and_return(ability)
          allow(ability).to receive(:can?).with(:order_copy_cards, registration).and_return(can)
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
          let(:registration) { double(:registration) }

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
