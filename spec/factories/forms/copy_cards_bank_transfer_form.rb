# frozen_string_literal: true

FactoryBot.define do
  factory :copy_cards_bank_transfer_form, class: "CopyCardsBankTransferForm" do
    trait :has_required_data do
      initialize_with { new(create(:order_copy_cards_registration, workflow_state: "copy_cards_bank_transfer_form")) }
    end
  end
end
