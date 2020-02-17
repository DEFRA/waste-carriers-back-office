# frozen_string_literal: true

class CashPaymentForm < BasePaymentForm
  def submit(params)
    payment_type_value = "CASH"
    super(params, payment_type_value)
  end
end
