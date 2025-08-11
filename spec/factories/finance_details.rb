# frozen_string_literal: true

FactoryBot.define do
  factory :finance_details, class: "WasteCarriersEngine::FinanceDetails" do

    transient do
      payment_type { :bank_transfer }
      payment_amount { 0 }
      payment_date_entered { Time.zone.today }
    end

    trait :positive_balance do
      balance { 100 }
    end

    trait :has_paid_order_and_payment do
      orders { [build(:order, :has_required_data)] }
      payments do
        [
          build(:payment, payment_type, date_entered: payment_date_entered, amount: Rails.configuration.renewal_charge),
          build(:payment, payment_type, date_entered: payment_date_entered, amount: Rails.configuration.card_charge)
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
        [build(:payment, :govpay, date_entered: payment_date_entered, govpay_payment_status: WasteCarriersEngine::Payment::STATUS_SUCCESS, amount: 100_500)]
      end
      after(:build, :create, &:update_balance)
    end

    trait :has_overpaid_order_and_payment_bank_transfer do
      orders { [build(:order, :has_required_data)] }
      payments do
        [build(:payment, :bank_transfer, date_entered: payment_date_entered, amount: 100_500)]
      end
      after(:build, :create, &:update_balance)
    end

    trait :has_double_paid_order_and_payment_bank_transfer do
      orders { [build(:order, :has_required_data)] }
      payments do
        [
          build(:payment, :bank_transfer, date_entered: payment_date_entered, amount: 11_000),
          build(:payment, :bank_transfer, date_entered: payment_date_entered, amount: 11_000)
        ]
      end
      after(:build, :create, &:update_balance)
    end

    trait :has_copy_cards_order do
      orders { [build(:order, :has_copy_cards_item)] }
      after(:build, :create, &:update_balance)
    end

    trait :has_edit_order do
      orders { [build(:order, :has_type_change_item)] }
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
