# frozen_string_literal: true

module TransientPaymentsHelper
  # We use this to iterate over each valid payment type to check abilities. For example, `can :record_cash_payment`
  def record_payment_of_type(payment_type)
    :"record_#{payment_type}_payment"
  end
end
