# frozen_string_literal: true

FactoryBot.define do
  factory :order_copy_cards_registration, class: "OrderCopyCardsRegistration" do
    initialize_with { new(reg_identifier: create(:registration, :active, contact_email: defined?(contact_email) ? contact_email : nil).reg_identifier) }

    trait :has_finance_details do
      temp_cards { 1 }
      finance_details { association(:finance_details, :has_copy_cards_order, strategy: :build) }
    end

    trait :copy_cards_payment_form_state do
      workflow_state { :copy_cards_payment_form }
      temp_cards { 1 }
    end
  end
end
