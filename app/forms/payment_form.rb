# frozen_string_literal: true

class PaymentForm
  include ActiveModel::Model

  attr_accessor :payment_type

  validates :payment_type, presence: true

  def submit(params)
    self.payment_type = params[:payment_type]

    valid?
  end
end
