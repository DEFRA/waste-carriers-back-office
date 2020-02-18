# frozen_string_literal: true

class PositiveChargeAdjustForm < WasteCarriersEngine::BaseForm
  include CanHaveChargeAdjustAttributes
  include CanConvertStringToPence

  def submit(params)
    # Assign the params for validation
    self.amount = params[:amount]
    self.reference = params[:reference]
    self.description = params[:description]

    return false unless valid?

    self.amount = string_to_pence(amount)

    ProcessChargeAdjustService.run(
      finance_details: transient_registration.finance_details,
      form: self,
      user: params[:current_user]
    )

    true
  end
end
