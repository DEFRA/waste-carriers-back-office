# frozen_string_literal: true

require "rails_helper"

RSpec.describe TransientRegistrationCleanupService do
  describe ".run" do
    let(:transient_registration) { create(:new_registration) }
    let(:token) { transient_registration.token }

    context "when a transient_registration has not been modified in more than 30 days" do
      before do
        transient_registration.metaData.update_attributes!(last_modified: Time.now - 31.days)
      end

      it "deletes it" do
        expect { described_class.run }.to change { WasteCarriersEngine::TransientRegistration.where(token: token).count }.from(1).to(0)
      end
    end

    context "when a transient_registration has been modified in the last 30 days" do
      it "does not delete it" do
        expect { described_class.run }.to_not change { WasteCarriersEngine::TransientRegistration.where(token: token).count }.from(1)
      end
    end
  end
end
