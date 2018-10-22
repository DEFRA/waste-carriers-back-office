# frozen_string_literal: true

class RegistrationTransferService
  def initialize(registration)
    @registration = registration
    @transient_registration = find_transient_registration
  end

  def transfer_to_user(email)
    @recipient_user = find_user(email)

    return :no_matching_user if @recipient_user.blank?
  end

  private

  def find_transient_registration
    WasteCarriersEngine::TransientRegistration.where(reg_identifier: @registration.reg_identifier).first
  end

  def find_user(email)
    return nil unless email.present?

    ExternalUser.where(email: email).first
  end
end
