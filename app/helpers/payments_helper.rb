# frozen_string_literal: true

module PaymentsHelper
  # We use this to iterate over each valid payment type to check abilities. For example, `can :record_cash_payment`
  def record_payment_of_type(payment_type)
    "record_#{payment_type}_payment".to_sym
  end
end
