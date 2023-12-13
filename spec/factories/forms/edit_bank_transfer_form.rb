# frozen_string_literal: true

FactoryBot.define do
  factory :edit_bank_transfer_form, class: "EditBankTransferForm" do
    trait :has_required_data do
      initialize_with { new(create(:edit_registration, workflow_state: "edit_bank_transfer_form")) }
    end
  end
end
