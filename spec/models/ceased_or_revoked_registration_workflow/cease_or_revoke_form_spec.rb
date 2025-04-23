# frozen_string_literal: true

require "rails_helper"

RSpec.describe CeaseOrRevokeForm do
  subject(:ceased_or_revoked_registration) { build(:ceased_or_revoked_registration, workflow_state: "cease_or_revoke_form") }

  describe "#workflow_state" do
    context "with :cease_or_revoke_form state transitions" do
      context "with :next transition" do
        it_behaves_like "has next transition", next_state: "ceased_or_revoked_confirm_form"
      end
    end
  end
end
