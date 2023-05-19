# frozen_string_literal: true

class GovpayFindPaymentService < WasteCarriersEngine::BaseService

  def run(payment_id:)
    # Because payments are embedded in finance_details, they don't have their own
    # collection so we can't search for them directly. We need to:
    # 1. find the registration which contains the payment with this govpay_id
    # 2. within that registration, find which payment has that govpay_id
    WasteCarriersEngine::Registration
      .find_by("financeDetails.payments.govpay_id": payment_id)
      .finance_details
      .payments
      .find_by(govpay_id: payment_id)
  rescue Mongoid::Errors::DocumentNotFound => e
    Rails.logger.error "Govpay payment not found for govpay_id #{payment_id}"
    Airbrake.notify(e, message: "Govpay payment not found", payment_id:)
    raise ArgumentError, "invalid govpay_id"
  end
end
