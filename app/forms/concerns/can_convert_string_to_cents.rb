# frozen_string_literal: true

module CanConvertStringToCents
  extend ActiveSupport::Concern

  included do
    # Converts "20.00" to 2000
    def string_to_cents(string)
      (string.to_d * 100).to_i
    end
  end
end
