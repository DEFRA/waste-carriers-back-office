# frozen_string_literal: true

class WorldpayMissedPaymentForm < PaymentForm
  def submit(params)
    payment_type_value = "WORLDPAY_MISSED"
    super(params, payment_type_value)
  end
end
