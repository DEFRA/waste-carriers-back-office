# frozen_string_literal: true

class NegativeChargeAdjustForm < WasteCarriersEngine::BaseForm
  include CanHaveChargeAdjustAttributes
  include CanConvertStringToPence

  def submit(params)
    # Assign the params for validation
    self.amount = params[:amount]
    self.reference = params[:reference]
    self.description = params[:description]

    return false unless valid?

    # Negative amount as this is a negative charge adjust
    self.amount = string_to_pence(amount) * -1

    true
  end
end
