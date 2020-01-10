# frozen_string_literal: true

class RefundPresenter < WasteCarriersEngine::BasePresenter
  def initialize(finance_details, payment)
    @payment = payment

    super(finance_details, nil)
  end

  def total_amount_paid
    @_total_amount_paid ||= payments.inject(0) do |memo, payment|
      memo + payment.amount
    end
  end

  def total_amount_due
    @_total_amount_due ||= orders.inject(0) do |memo, order|
      memo + order.total_amount
    end
  end

  def balance_to_refund
    # Little math trick to transform negative value to positive values
    overpayment = (balance * -1)

    [overpayment, payment.amount].min
  end

  private

  attr_reader :payment
end
