# frozen_string_literal: true

class RecordBankTransferRefundService < WasteCarriersEngine::BaseService
  def run(finance_details:, payment:, user:)
    @finance_details = finance_details
    @payment = payment
    @user = user

    refund_amount = amount_to_refund
    if refund_amount.positive?
      refund = build_bank_transfer_refund(refund_amount)
      finance_details.payments << refund
      finance_details.update_balance
      finance_details.save!
    end

    true
  rescue StandardError => e
    Rails.logger.error "#{e.class} error processing refund for payment #{payment.order_key}"
    Airbrake.notify(e, message: "Error processing refund for payment ", order_key: payment.order_key)
    false
  end

  private

  attr_reader :payment, :user, :finance_details, :reason

  def build_bank_transfer_refund(amount)
    WasteCarriersEngine::Payment.new(
      payment_type: WasteCarriersEngine::Payment::REFUND,
      order_key: "#{payment.order_key}_REFUNDED",
      amount: -amount,
      date_entered: Date.current,
      date_received: Date.current,
      registration_reference: payment.registration_reference,
      updated_by_user: user.email,
      comment: "Bank transfer payment refunded"
    )
  end

  def amount_to_refund
    return 0 unless finance_details.balance.negative?

    overpayment = (finance_details.balance * -1)
    [overpayment, payment.amount].min
  end
end
