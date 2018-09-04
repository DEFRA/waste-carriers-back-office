# frozen_string_literal: true

class TransferPaymentForm < PaymentForm
  def submit(params)
    payment_type_value = "BANKTRANSFER"
    super(params, payment_type_value)
  end
end
