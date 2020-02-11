# frozen_string_literal: true

module CanHaveChargeAdjustAttributes
  extend ActiveSupport::Concern

  included do
    attr_accessor :amount, :reference, :description

    # Format: 102.30 - At least a digit, can have a dot and up to two digits after it.
    validates :amount, presence: true, format: { with: /\A\d+\.?\d?\d?\z/ }
    validates :reference, presence: true
    validates :description, presence: true, length: { maximum: 500 }
  end
end
