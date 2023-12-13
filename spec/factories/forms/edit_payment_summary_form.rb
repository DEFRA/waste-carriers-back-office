# frozen_string_literal: true

FactoryBot.define do
  factory :edit_payment_summary_form, class: "EditPaymentSummaryForm" do
    trait :has_required_data do
      initialize_with { new(create(:edit_registration, workflow_state: "edit_payment_summary_form")) }
    end
  end
end
