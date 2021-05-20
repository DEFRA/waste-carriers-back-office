# frozen_string_literal: true

class RegistrationTransferForm < WasteCarriersEngine::BaseForm
  attr_accessor :email, :confirm_email, :registration

  def initialize(registration)
    self.registration = registration
    super
  end

  def submit(params)
    self.email = params[:email]&.downcase
    self.confirm_email = params[:confirm_email]&.downcase

    return false unless valid?

    transfer_registration!
  end

  validates :email, :confirm_email, "defra_ruby/validators/email": true
  validates :confirm_email, "waste_carriers_engine/matching_email": { compare_to: :email }

  def transfer_registration!
    result = RegistrationTransferService.run(registration: registration, email: email)

    return true if %i[success_existing_user success_new_user].include?(result)

    # This is to handle a `no_matching_user` return code.
    # Currently, the service only checks for the presence of an email, and
    # as the email already been validated, this scenario shouldn't happen.
    errors[:email] << I18n.t("activemodel.errors.models.registration_transfer_form.attributes.email.#{result}")
    false
  end
end
