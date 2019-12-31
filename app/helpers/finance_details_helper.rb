# frozen_string_literal: true

module FinanceDetailsHelper
  def display_pence_as_pounds_and_cents(pence)
    pounds = pence.to_f / 100

    format("%<pounds>.2f", pounds: pounds)
  end
end
