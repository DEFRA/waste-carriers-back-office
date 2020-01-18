# frozen_string_literal: true

class WriteOffForm < WasteCarriersEngine::BaseForm
  attr_accessor :comment

  validates :comment, presence: true, length: { maximum: 250 }

  def submit(params)
    # Assign the params for validation
    self.comment = params[:comment]

    return false unless valid?

    # TODO
    # response = ProcessWriteOffService.run(
    #   finance_details: @registration.finance_details,
    #   user: current_user
    # )

    # return false unless response

    true
  end
end
