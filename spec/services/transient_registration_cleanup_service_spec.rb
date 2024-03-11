# frozen_string_literal: true

require "rails_helper"

RSpec.describe TransientRegistrationCleanupService do
  describe ".run" do
    before do
      allow(Rails.configuration).to receive(:max_transient_registration_age_days).and_return("30")
    end

    let(:transient_registration) { create(:new_registration) }
    let(:token) { transient_registration.token }

    shared_examples "deletes it" do
      it do
        expect { described_class.run }
          .to change { WasteCarriersEngine::TransientRegistration.where(token: token).count }
          .from(1).to(0)
      end
    end

    shared_examples "does not delete it" do
      it do
        expect { described_class.run }
          .not_to change { WasteCarriersEngine::TransientRegistration.where(token: token).count }
          .from(1)
      end
    end

    context "when a transient_registration was created more than 30 days ago" do
      before { transient_registration.update(created_at: 31.days.ago) }

      it_behaves_like "deletes it"

      context "when the transient_registration is a submitted registration with a pending payment" do
        let(:transient_registration) { create(:new_registration, workflow_state: "registration_received_pending_payment_form") }

        it_behaves_like "deletes it"
      end

      context "when the transient_registration is a submitted renewal with a pending payment" do
        let(:transient_registration) { create(:renewing_registration, workflow_state: "renewal_received_pending_payment_form") }

        it_behaves_like "deletes it"
      end

      context "when the transient_registration is a submitted renewal with a pending conviction check" do
        let(:transient_registration) { create(:renewing_registration, workflow_state: "renewal_received_pending_conviction_form") }

        it_behaves_like "does not delete it"
      end

      context "when the transient_registration was last modified within the last 30 days" do
        before { transient_registration.metaData.set(last_modified: 31.days.ago) }

        it_behaves_like "deletes it"
      end
    end

    context "when a transient_registration was created within the last 30 days" do
      it_behaves_like "does not delete it"
    end

    context "when a transient_registration has no created_at" do
      before { transient_registration.unset(:created_at) }

      context "when a transient_registration was last modified more than 30 days ago" do
        before { transient_registration.metaData.set(last_modified: 31.days.ago) }

        it_behaves_like "deletes it"

        context "when the transient_registration is a submitted renewal" do
          let(:transient_registration) { create(:renewing_registration, workflow_state: "renewal_received_pending_conviction_form") }

          it_behaves_like "does not delete it"
        end
      end

      context "when a transient_registration was last modified within the last 30 days" do
        before { transient_registration.metaData.set(last_modified: 1.day.ago) }

        it_behaves_like "does not delete it"
      end
    end

    # This can happen when a transient_registration class is renamed or retired
    # if transient_registrations of the old type remain in the DB.
    context "when a transient_registration has an invalid _type" do
      shared_examples "deletes the transient registration" do |type_name|
        before do
          transient_registration.update(created_at: 31.days.ago, _type: type_name)
        end

        # validate test setup
        it { expect(WasteCarriersEngine::TransientRegistration.pluck(:_type)).to eq [type_name] }

        it { expect { described_class.run }.not_to raise_error }

        it_behaves_like "deletes it"
      end

      it_behaves_like "deletes the transient registration", "NonExistentClass"

      it_behaves_like "deletes the transient registration", "WasteCarriersEngine::NonExistentClass"
    end
  end
end
