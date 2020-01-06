# frozen_string_literal: true

class ProcessRefundService < WasteCarriersEngine::BaseService
  def run(finance_details:, payment:, user:)
    @payment = payment
    @user = user

    return false if card_payment? && !card_refund_result

    finance_details.payments << build_refund

    finance_details.update_balance
    finance_details.save!

    true
  end

  private

  attr_reader :payment, :user

  def card_refund_result
    @_card_refund_result ||= ::Worldpay::RefundService.run(payment: payment)
  end

  def build_refund
    refund = WasteCarriersEngine::Payment.new(payment_type: WasteCarriersEngine::Payment::REFUND)

    refund.order_key = "#{payment.order_key}_REFUNDED"
    refund.amount = payment.amount * -1
    refund.date_entered = Date.current
    refund.date_received = Date.current
    refund.registration_reference = payment.registration_reference
    refund.updated_by_user = user.email
    refund.comment = refund_comment

    refund
  end

  def card_payment?
    payment.worldpay? || payment.worldpay_missed?
  end

  def refund_comment
    return I18n.t("refunds.comment.card") if card_payment?

    I18n.t("refunds.comment.manual")
  end
end
