# frozen_string_literal: true

class ProcessRefundService < WasteCarriersEngine::BaseService
  attr_reader :payment

  def run(finance_details:, payment:, user:)
    finance_details.payments << build_refund_for(payment, user)

    finance_details.update_balance
    finance_details.save!
  end

  private

  def build_refund_for(payment, user)
    refund = WasteCarriersEngine::Payment.new(payment_type: WasteCarriersEngine::Payment::REFUND)

    refund.order_key = "#{payment.order_key}_REFUNDED"
    refund.amount = payment.amount * -1
    refund.date_entered = Date.current
    refund.date_received = Date.current
    refund.registration_reference = payment.registration_reference
    refund.updated_by_user = user.email

    refund.comment = I18n.t("refunds.comment.manual")
    refund.comment = I18n.t("refunds.comment.card") if payment.worldpay? || payment.worldpay_missed?

    refund
  end
end
