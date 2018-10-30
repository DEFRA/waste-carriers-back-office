# frozen_string_literal: true

class RegistrationTransferForm < WasteCarriersEngine::BaseForm
  attr_accessor :email, :confirm_email

  def initialize(registration)
    super
  end

  def submit(params)
    self.email = params[:email]
    self.confirm_email = params[:confirm_email]

    attributes = {}

    super(attributes, params[:reg_identifier])
  end

  validates :email, :confirm_email, presence: true
end
