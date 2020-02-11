# frozen_string_literal: true

class ProcessReversalService < WasteCarriersEngine::BaseService
  def run(finance_details:, payment:, user:, reason:)
    @finance_details = finance_details
    @payment = payment
    @user = user
    @reason = reason

    finance_details.payments << build_reversal

    finance_details.update_balance
    finance_details.save!
  end

  private

  attr_reader :payment, :user, :finance_details, :reason

  def build_reversal
    reversal = WasteCarriersEngine::Payment.new(payment_type: WasteCarriersEngine::Payment::REVERSAL)

    reversal.order_key = "#{payment.order_key}_REVERSAL"
    reversal.amount = -payment.amount
    reversal.date_entered = Date.current
    reversal.date_received = Date.current
    reversal.registration_reference = payment.registration_reference
    reversal.updated_by_user = user.email
    reversal.comment = reason

    reversal
  end
end
