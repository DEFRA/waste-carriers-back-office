# frozen_string_literal: true

class RegistrationTransferService
  def initialize(registration)
    @registration = registration
    @transient_registration = find_transient_registration
  end

  private

  def find_transient_registration
    WasteCarriersEngine::TransientRegistration.where(reg_identifier: @registration.reg_identifier).first
  end
end
