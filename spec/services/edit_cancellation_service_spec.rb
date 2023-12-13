# frozen_string_literal: true

require "rails_helper"

RSpec.describe EditCancellationService do
  describe "run" do
    let(:edit_registration) { instance_double(EditRegistration) }

    it "deletes the edit_registration" do
      allow(edit_registration).to receive(:delete)

      described_class.run(edit_registration: edit_registration)

      expect(edit_registration).to have_received(:delete)
    end
  end
end
