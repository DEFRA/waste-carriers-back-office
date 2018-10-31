# frozen_string_literal: true

class RegistrationTransferForm < WasteCarriersEngine::BaseForm
  attr_accessor :email, :confirm_email, :registration

  def initialize(registration)
    self.registration = registration
    super
  end

  def submit(params)
    self.email = params[:email]
    self.confirm_email = params[:confirm_email]

    attributes = {}

    super(attributes, params[:reg_identifier])
  end

  validates :email, :confirm_email, "waste_carriers_engine/email": true
  validates :confirm_email, "waste_carriers_engine/matching_email": { compare_to: :email }
  validate :registration_transferred_successfully?

  def registration_transferred_successfully?
    registration_transfer_service = RegistrationTransferService.new(registration)
    result = registration_transfer_service.transfer_to_user(email)

    return true if result == :success_existing_user

    errors[:email] << I18n.t("activemodel.errors.models.registration_transfer_form.attributes.email.#{result}")
    false
  end
end
