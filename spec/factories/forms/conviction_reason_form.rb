# frozen_string_literal: true

FactoryBot.define do
  factory :conviction_reason_form do
    revoked_reason { "foo" }

    initialize_with do
      new(create(:renewing_registration,
                 :requires_conviction_check,
                 workflow_state: "renewal_received_pending_conviction_form"))
    end
  end
end
