# frozen_string_literal: true

require "rails_helper"

RSpec.describe TransientRegistrationCleanupService do
  describe ".run" do
    before do
      allow(Rails.configuration).to receive(:max_transient_registration_age_days).and_return("30")
    end

    let(:transient_registration) { create(:new_registration) }
    let(:token) { transient_registration.token }

    context "when a transient_registration was created more than 30 days ago" do
      before do
        transient_registration.update(created_at: Time.zone.now - 31.days)
      end

      it "deletes it" do
        expect { described_class.run }.to change { WasteCarriersEngine::TransientRegistration.where(token: token).count }.from(1).to(0)
      end

      context "when the transient_registration is a submitted renewal" do
        let(:transient_registration) { create(:renewing_registration, workflow_state: "renewal_received_pending_payment_form") }

        it "does not delete it" do
          expect { described_class.run }.not_to change { WasteCarriersEngine::TransientRegistration.where(token: token).count }.from(1)
        end
      end

      context "when the transient_registration was last modified within the last 30 days" do
        before do
          transient_registration.metaData.set(last_modified: Time.zone.now - 31.days)
        end

        it "deletes it" do
          expect { described_class.run }.to change { WasteCarriersEngine::TransientRegistration.where(token: token).count }.from(1).to(0)
        end
      end
    end

    context "when a transient_registration was created within the last 30 days" do
      it "does not delete it" do
        expect { described_class.run }.not_to change { WasteCarriersEngine::TransientRegistration.where(token: token).count }.from(1)
      end
    end

    context "when a transient_registration has no created_at" do
      before do
        transient_registration.unset(:created_at)
      end

      context "when a transient_registration was last modified more than 30 days ago" do
        before do
          transient_registration.metaData.set(last_modified: Time.zone.now - 31.days)
        end

        it "deletes it" do
          expect { described_class.run }.to change { WasteCarriersEngine::TransientRegistration.where(token: token).count }.from(1).to(0)
        end

        context "when the transient_registration is a submitted renewal" do
          let(:transient_registration) { create(:renewing_registration, workflow_state: "renewal_received_pending_payment_form") }

          it "does not delete it" do
            expect { described_class.run }.not_to change { WasteCarriersEngine::TransientRegistration.where(token: token).count }.from(1)
          end
        end
      end

      context "when a transient_registration was last modified within the last 30 days" do
        before do
          transient_registration.metaData.set(last_modified: Time.zone.now - 1.days)
        end

        it "does not delete it" do
          expect { described_class.run }.not_to change { WasteCarriersEngine::TransientRegistration.where(token: token).count }.from(1)
        end
      end
    end
  end
end
