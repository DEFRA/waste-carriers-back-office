# frozen_string_literal: true

FactoryBot.define do
  factory :finance_details, class: WasteCarriersEngine::FinanceDetails do

    transient do
      payment_type { :bank_transfer }
      payment_amount { 0 }
      payment_date_entered { Date.today }
    end

    trait :positive_balance do
      balance { 100 }
    end

    trait :has_paid_order_and_payment do
      orders { [build(:order, :has_required_data)] }
      payments do
        [
          build(:payment, payment_type, date_entered: payment_date_entered, amount: 10_500),
          build(:payment, payment_type, date_entered: payment_date_entered, amount: 500)
        ]
      end
      after(:build, :create, &:update_balance)
    end

    trait :has_unpaid_order do
      orders { [build(:order, :has_required_data)] }

      after(:build, :create, &:update_balance)
    end

    # TODO: When retiring worldpay code, retire this trait in favour of the _govpay version below.
    trait :has_overpaid_order_and_payment do
      orders { [build(:order, :has_required_data)] }
      payments do
        [build(:payment, :worldpay, date_entered: payment_date_entered, world_pay_payment_status: "AUTHORISED", amount: 100_500)]
      end
      after(:build, :create, &:update_balance)
    end

    trait :has_overpaid_order_and_payment_govpay do
      orders { [build(:order, :has_required_data)] }
      payments do
        [build(:payment, :govpay, date_entered: payment_date_entered, govpay_payment_status: "success", amount: 100_500)]
      end
      after(:build, :create, &:update_balance)
    end

    trait :has_single_payment do
      orders { [build(:order, :has_required_data)] }
      payments do
        [build(:payment, payment_type, date_entered: payment_date_entered, amount: payment_amount)]
      end
      after(:build, :create, &:update_balance)
    end

    trait :zero_balance do
      balance { 0 }
    end
  end
end
