# frozen_string_literal: true

class RegistrationTransferForm < WasteCarriersEngine::BaseForm
  attr_accessor :email, :confirm_email

  def initialize(registration)
    super
  end

  def submit(params)
    attributes = {}

    super(attributes, params[:reg_identifier])
  end

  validates :email, :confirm_email, presence: true
end
