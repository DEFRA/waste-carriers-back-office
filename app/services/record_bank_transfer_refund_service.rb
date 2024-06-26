# frozen_string_literal: true

class RecordBankTransferRefundService < WasteCarriersEngine::BaseService
  def run(finance_details:, payment:, user:)
    @finance_details = finance_details
    @payment = payment
    @user = user

    finance_details.payments << build_bank_transfer_refund

    finance_details.update_balance
    finance_details.save!
  end

  private

  attr_reader :payment, :user, :finance_details, :reason

  def build_bank_transfer_refund
    refund = WasteCarriersEngine::Payment.new(payment_type: WasteCarriersEngine::Payment::REFUND)

    refund.order_key = "#{payment.order_key}_REFUNDED"
    refund.amount = -payment.amount
    refund.date_entered = Date.current
    refund.date_received = Date.current
    refund.registration_reference = payment.registration_reference
    refund.updated_by_user = user.email
    refund.comment = "Bank transfer payment refunded"

    refund
  end
end
