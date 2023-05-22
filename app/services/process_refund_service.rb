# frozen_string_literal: true

class ProcessRefundService < WasteCarriersEngine::BaseService
  def run(finance_details:, payment:, user:)
    @finance_details = finance_details
    @payment = payment
    @user = user

    return false if amount_to_refund.zero?
    return false if card_payment? && refund_details.blank?

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

  attr_reader :payment, :user, :finance_details

  def refund_details
    @refund_details ||= GovpayRefundService.run(
      payment: payment,
      amount: amount_to_refund
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

    if payment.govpay?
      assign_govpay_attributes(refund, payment)
    else
      refund.order_key = "#{payment.order_key}_SUBMITTED"
    end
    refund.amount = -amount_to_refund
    refund.date_entered = Date.current
    refund.date_received = Date.current
    refund.registration_reference = payment.registration_reference
    refund.updated_by_user = user.email
    refund.comment = refund_comment

    refund
  end

  def assign_govpay_attributes(refund, payment)
    refund.govpay_payment_status = "submitted"
    refund.govpay_id = @refund_details["refund_id"]
    refund.refunded_payment_govpay_id = payment.govpay_id
    refund.order_key = "#{payment.order_key}_PENDING"
  end

  def order
    @_order ||= finance_details.orders.find_by(order_code: payment.order_key)
  end

  def card_payment?
    payment.govpay?
  end

  def refund_comment
    return I18n.t("refunds.comments.card_pending") if card_payment?

    I18n.t("refunds.comments.manual")
  end
end
