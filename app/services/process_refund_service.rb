# frozen_string_literal: true

class ProcessRefundService < WasteCarriersEngine::BaseService
  def run(finance_details:, payment:, user:, refunder: ::Worldpay::RefundService)
    @finance_details = finance_details
    @payment = payment
    @user = user
    @refunder = refunder

    return false if amount_to_refund.zero?
    return false if card_payment? && !refunded?

    finance_details.payments << build_refund
    finance_details.update_balance
    finance_details.save!

    true
  rescue StandardError => e
    Rails.logger.error "#{e.class} error processing refund for payment #{payment.govpay_id}"
    Airbrake.notify(e, message: "Error processing refund for payment ", govpay_id: payment.govpay_id)

    false
  end

  private

  attr_reader :payment, :user, :finance_details, :refunder

  def refunded?
    Rails.logger.warn "\n============ process_refund_service\n"
    Rails.logger.warn "\n============ process_refund_service, refunder: #{refunder}\n"
    @_refunded ||= refunder.run(
      payment: payment,
      amount: amount_to_refund,
      merchant_code: order.merchant_id
    )
  end

  def amount_to_refund
    # We can never refund unless there have been an overpayment.
    return 0 unless finance_details.balance.negative?

    overpayment = (finance_details.balance * -1)

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

    refund.world_pay_payment_status = "AUTHORISED" if payment.worldpay?

    refund
  end

  def order
    @_order ||= finance_details.orders.find_by(order_code: payment.order_key)
  end

  def card_payment?
    payment.worldpay? || payment.govpay?
  end

  def refund_comment
    return I18n.t("refunds.comments.card", type: payment.payment_type.titleize) if card_payment?

    I18n.t("refunds.comments.manual")
  end
end
