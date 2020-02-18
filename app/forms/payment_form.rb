# frozen_string_literal: true

class PaymentForm
  include ActiveModel::Model

  PAYMENT_TYPES = %w[cash cheque postal_order bank_transfer worldpay_missed].freeze

  attr_accessor :payment_type

  validates :payment_type, inclusion: { in: PAYMENT_TYPES }

  def submit(params)
    self.payment_type = params[:payment_type]

    valid?
  end
end
