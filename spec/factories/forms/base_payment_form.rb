# frozen_string_literal: true

FactoryBot.define do
  factory :base_payment_form do
    amount { 100 }
    comment { "foo" }
    updated_by_user { build(:user).email }
    registration_reference { "foo" }

    date_received_day { 1 }
    date_received_month { 1 }
    date_received_year { 2018 }

    date_received { Date.new(2018, 1, 1) }

    initialize_with do
      new(create(:renewing_registration,
                 :has_finance_details,
                 workflow_state: "renewal_received_form"))
    end
  end
end
