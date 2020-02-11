# frozen_string_literal: true

module CanConvertStringToPence
  extend ActiveSupport::Concern

  included do
    # Converts "20.00" to 2000
    def string_to_pence(string)
      (string.to_d * 100).to_i
    end
  end
end
