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

  def already_reverted?
    reverted_payment.present?
  end

  def refunded_message
    if worldpay?
      I18n.t(".refunds.refunded_message.card", refund_status: refunded_payment.world_pay_payment_status)
    else
      I18n.t(".refunds.refunded_message.manual")
    end
  end

  def no_action_message
    if already_reverted?
      I18n.t(".reversal_forms.index.already_reversed")
    else
      I18n.t(".reversal_forms.index.not_aplicable")
    end
  end

  def revertible?
    return false unless @view.current_user.can?(:revert, __getobj__)
    return false if already_reverted?

    true
  end

  private

  def refunded_payment
    @_refunded_payment ||= finance_details.payments.where(order_key: "#{order_key}_REFUNDED").first
  end

  def reverted_payment
    @_reverted_payment ||= finance_details.payments.where(order_key: "#{order_key}_REVERSAL").first
  end
end
