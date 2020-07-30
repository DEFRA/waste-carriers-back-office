# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe Registration do

    describe "#can_start_front_office_renewal?" do
      let(:registration) { build(:registration) }

      context "when the registration is lower tier" do
        before { registration.tier = "LOWER" }

        it "returns false" do
          expect(registration.can_start_front_office_renewal?).to eq(false)
        end
      end

      context "when the registration is upper tier" do
        before { registration.tier = "UPPER" }

        context "when the registration has been revoked or refused" do
          before { registration.metaData.status = %w[REVOKED REFUSED].sample }

          it "returns false" do
            expect(registration.can_start_front_office_renewal?).to eq(false)
          end
        end

        context "when the registration has not been revoked or refused" do
          before { registration.metaData.status = "ACTIVE" }

          context "when the registration is in the standard grace window" do
            before { expect_any_instance_of(ExpiryCheckService).to receive(:in_standard_expiry_grace_window?).and_return(true) }

            it "returns true" do
              expect(registration.can_start_front_office_renewal?).to eq(true)
            end
          end

          context "when the registration is not in the standard grace window" do
            before { expect_any_instance_of(ExpiryCheckService).to receive(:in_standard_expiry_grace_window?).and_return(false) }

            context "when the registration is past the expiry date" do
              before { expect_any_instance_of(ExpiryCheckService).to receive(:expired?).and_return(true) }

              it "returns false" do
                expect(registration.can_start_front_office_renewal?).to eq(false)
              end
            end

            context "when the registration is not past the expiry date" do
              before { expect_any_instance_of(ExpiryCheckService).to receive(:expired?).and_return(false) }

              context "when the registration is in the renewal window" do
                before { expect_any_instance_of(ExpiryCheckService).to receive(:in_renewal_window?).and_return(true) }

                it "returns true" do
                  expect(registration.can_start_front_office_renewal?).to eq(true)
                end
              end

              context "when the result is not in the renewal window" do
                before { expect_any_instance_of(ExpiryCheckService).to receive(:in_renewal_window?).and_return(false) }

                it "returns false" do
                  expect(registration.can_start_front_office_renewal?).to eq(false)
                end
              end
            end
          end
        end
      end
    end
  end
end
