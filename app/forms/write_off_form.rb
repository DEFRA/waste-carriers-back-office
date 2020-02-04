# frozen_string_literal: true

class WriteOffForm < WasteCarriersEngine::BaseForm
  attr_accessor :comment

  validates :comment, presence: true, length: { maximum: 500 }

  def submit(params, user)
    # Assign the params for validation
    self.comment = params[:comment]

    return false unless valid?

    ProcessWriteOffService.run(
      finance_details: transient_registration.finance_details,
      user: user,
      comment: comment
    )

    true
  end
end
