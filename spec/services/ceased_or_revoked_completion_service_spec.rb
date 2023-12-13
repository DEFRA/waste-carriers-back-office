# frozen_string_literal: true

require "rails_helper"

RSpec.describe CeasedOrRevokedCompletionService do
  describe ".run" do
    let(:transient_registration) { create(:ceased_or_revoked_registration) }
    let(:registration) { transient_registration.registration }
    let(:registration_metadata) { registration.metaData }
    let(:transient_registration_metadata) { transient_registration.metaData }
    let(:revoked_reason) { instance_double(String) }
    let(:user) { create(:user) }

    before do
      allow(WasteCarriersEngine.configuration).to receive(:host_is_back_office?).and_return(true)
      allow(registration_metadata).to receive(:status=)
      allow(registration_metadata).to receive(:revoked_reason=)
      allow(registration).to receive(:save!)
      allow(transient_registration_metadata).to receive(:revoked_reason).and_return(revoked_reason)
      allow(transient_registration).to receive(:destroy)
    end

    it "copies metadata from transient object to registration" do

      described_class.run(transient_registration:, user:)

      expect(registration_metadata).to have_received(:status=).with("REVOKED")
      expect(registration_metadata).to have_received(:revoked_reason=).with(revoked_reason)

      expect(transient_registration).to have_received(:destroy)
      expect(registration).to have_received(:save!)

    end
  end
end
