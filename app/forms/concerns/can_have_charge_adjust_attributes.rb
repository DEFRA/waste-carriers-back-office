# frozen_string_literal: true

module CanHaveChargeAdjustAttributes
  extend ActiveSupport::Concern

  included do
    attr_accessor :amount, :reference, :description

    validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
    validates :reference, presence: true
    validates :description, presence: true, length: { maximum: 500 }
  end
end
