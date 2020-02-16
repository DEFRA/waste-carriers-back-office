# frozen_string_literal: true

class ChargeAdjustForm
  include ActiveModel::Model

  attr_accessor :charge_type

  validates :charge_type, presence: true

  # This is here so that we can take advantage of our FormController interfaces
  def initialize(_resource); end;

  def submit(params)
    # Assign the params for validation
    self.charge_type = params[:charge_type]

    valid?
  end
end
