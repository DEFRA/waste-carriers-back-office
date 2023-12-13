# frozen_string_literal: true

class CeasedOrRevokedRegistration < WasteCarriersEngine::TransientRegistration
  include CanUseCeasedOrRevokedRegistrationWorkflow

  validates :reg_identifier, "waste_carriers_engine/reg_identifier": true

  delegate :company_name, :registration_type, :tier, :contact_address, to: :registration

  def registration
    @_registration ||= WasteCarriersEngine::Registration.find_by(reg_identifier: reg_identifier)
  end
end
