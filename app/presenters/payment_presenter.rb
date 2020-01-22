# frozen_string_literal: true

class PaymentPresenter < WasteCarriersEngine::BasePresenter
  include FinanceDetailsHelper

  def self.create_from_collection(payments, view)
    payments.map do |payment|
      new(payment, view)
    end
  end

  def already_refunded?
    refunded_payment.present?
  end

  def refunded_message
    if worldpay?
      I18n.t(".refunds.refunded_message.card", refund_status: refunded_payment.world_pay_payment_status)
    else
      I18n.t(".refunds.refunded_message.manual")
    end
  end

  def amount
    super && display_pence_as_pounds_and_cents(super)
  end

  private

  def refunded_payment
    @_refunded_payment ||= finance_details.payments.where(order_key: "#{order_key}_REFUNDED").first
  end
end
