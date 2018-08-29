# frozen_string_literal: true

FactoryBot.define do
  factory :conviction_reason_form do
    revoked_reason { "foo" }

    initialize_with do
      new(create(:transient_registration,
                 :requires_conviction_check,
                 workflow_state: "renewal_received_form"))
    end
  end
end
