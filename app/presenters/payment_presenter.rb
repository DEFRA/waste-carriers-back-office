# frozen_string_literal: true

class PaymentPresenter < WasteCarriersEngine::BasePresenter
  def self.create_from_collection(payments, view)
    payments.map do |payment|
      new(payment, view)
    end
  end

  def already_refunded?
    refunded_payment.present?
  end

  def refunded_message
    key = "manual"
    key = "card" if worldpay? || worldpay_missed?

    I18n.t(".refunds.refunded_message.#{key}", refund_status: refunded_payment.world_pay_payment_status)
  end

  private

  def refunded_payment
    @_refunded_payment ||= finance_details.payments.where(order_key: "#{order_key}_REFUNDED").first
  end
end
