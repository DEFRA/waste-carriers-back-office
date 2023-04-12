# frozen_string_literal: true

class RegistrationRestoreForm < WasteCarriersEngine::BaseForm
  include ActiveModel::Model

  attr_accessor :registration, :restored_reason

  validates :restored_reason, presence: true, length: { maximum: 500 }

  def initialize(registration)
    self.registration = registration
    super
  end

  def submit(params)
    self.restored_reason = params.dig(:registration_restore_form, :restored_reason)

    valid?
  end
end
