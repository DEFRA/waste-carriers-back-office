# frozen_string_literal: true

class ChequePaymentForm < PaymentForm
  def submit(params)
    payment_type_value = "CHEQUE"
    super(params, payment_type_value)
  end
end
