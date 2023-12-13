# frozen_string_literal: true

require "rails_helper"

RSpec.describe CeasedOrRevokedConfirmForm do
  subject(:ceased_or_revoked_registration) { build(:ceased_or_revoked_registration, workflow_state: "ceased_or_revoked_confirm_form") }

  describe "#workflow_state" do
    context "with :ceased_or_revoked_confirm_form state transitions" do
      context "with :next transition" do
        include_examples "has next transition", next_state: "ceased_or_revoked_completed_form"
      end
    end
  end
end
