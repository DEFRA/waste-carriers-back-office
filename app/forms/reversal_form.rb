# frozen_string_literal: true

class ReversalForm < WasteCarriersEngine::BaseForm
  attr_accessor :reason

  validates :reason, presence: true, length: { maximum: 500 }

  def submit(params)
    # Assign the params for validation
    self.reason = params[:reason]

    valid?
  end
end
