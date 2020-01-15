# frozen_string_literal: true

class ProcessRefundService < WasteCarriersEngine::BaseService
  def run(finance_details:, payment:, user:)
    @finance_details = finance_details
    @payment = payment
    @user = user

    return false if amount_to_refund.zero?
    return false if card_payment? && !card_refund_result

    finance_details.payments << build_refund

    finance_details.update_balance
    finance_details.save!

    true
  end

  private

  attr_reader :payment, :user, :finance_details

  def card_refund_result
    @_card_refund_result ||= ::Worldpay::RefundService.run(
      payment: payment,
      amount: amount_to_refund,
      merchant_code: order.merchant_id
    )
  end

  def amount_to_refund
    # We can never refund unless there have been an overpayment.
    return 0 unless finance_details.balance.negative?

    # A quick maths trick to convert a negative value to a postive one
    overpayment = (-1 * finance_details.balance)

    [overpayment, payment.amount].min
  end

  def build_refund
    refund = WasteCarriersEngine::Payment.new(payment_type: WasteCarriersEngine::Payment::REFUND)

    refund.order_key = "#{payment.order_key}_REFUNDED"
    refund.amount = -amount_to_refund
    refund.date_entered = Date.current
    refund.date_received = Date.current
    refund.registration_reference = payment.registration_reference
    refund.updated_by_user = user.email
    refund.comment = refund_comment

    refund
  end

  def order
    @_order ||= finance_details.orders.find_by(order_code: payment.order_key)
  end

  def card_payment?
    payment.worldpay?
  end

  def refund_comment
    return I18n.t("refunds.comment.card") if payment.worldpay? && payment.worldpay_missed?

    I18n.t("refunds.comment.manual")
  end
end
