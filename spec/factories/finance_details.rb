# frozen_string_literal: true

FactoryBot.define do
  factory :finance_details, class: WasteCarriersEngine::FinanceDetails do
    transient do
      payment_method { :bank_transfer }
    end

    trait :positive_balance do
      balance { 100 }
    end

    trait :has_paid_order_and_payment do
      orders { [build(:order, :has_required_data)] }
      payments do
        [
          build(:payment, :bank_transfer, amount: 10_500),
          build(:payment, :bank_transfer, amount: 500)
        ]
      end
      after(:build, :create, &:update_balance)
    end

    trait :has_unpaid_order do
      orders { [build(:order, :has_required_data)] }

      after(:build, :create, &:update_balance)
    end

    trait :has_overpaid_order_and_payment do
      orders { [build(:order, :has_required_data)] }
      payments do
        [
          build(:payment, :bank_transfer, amount: 100_500),
          build(:payment, :bank_transfer, amount: 500)
        ]
      end
      after(:build, :create, &:update_balance)
    end

    trait :has_overpaid_order_and_payment_govpay do
      orders { [build(:order, :has_required_data)] }
      payments do
        [
          build(:payment, :bank_transfer, amount: 100_500),
          build(:payment, :bank_transfer, amount: 500)
        ]
      end
      after(:build, :create, &:update_balance)
    end

    trait :zero_balance do
      balance { 0 }
    end
  end
end
