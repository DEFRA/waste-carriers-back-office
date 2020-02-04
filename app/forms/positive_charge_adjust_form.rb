# frozen_string_literal: true

class PositiveChargeAdjustForm < WasteCarriersEngine::BaseForm
  include CanHaveChargeAdjustAttributes
  include CanConvertStringToCents

  def submit(params)
    # Assign the params for validation
    self.amount = params[:amount]
    self.reference = params[:reference]
    self.description = params[:description]

    return false unless valid?

    self.amount = string_to_cents(amount)
  end
end
