# frozen_string_literal: true

class WriteOffForm < WasteCarriersEngine::BaseForm
  attr_accessor :comment

  validates :comment, presence: true, length: { maximum: 500 }

  def submit(params)
    # Assign the params for validation
    self.comment = params[:comment]

    valid?
  end
end
