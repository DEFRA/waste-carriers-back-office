# frozen_string_literal: true

class PostalOrderPaymentForm < PaymentForm
  def submit(params)
    payment_type_value = "POSTALORDER"
    super(params, payment_type_value)
  end
end
