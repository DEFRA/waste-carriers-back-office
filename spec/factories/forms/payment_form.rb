# frozen_string_literal: true

FactoryBot.define do
  factory :payment_form do
    amount { 100 }
    comment { "foo" }
    current_user_email { build(:user).email }
    order_key { "foo" }
    registration_reference { "foo" }

    date_received_day { 1 }
    date_received_month { 1 }
    date_received_year { 1991 }

    initialize_with do
      new(create(:transient_registration,
                 :has_finance_details,
                 workflow_state: "renewal_received_form"))
    end
  end
end
