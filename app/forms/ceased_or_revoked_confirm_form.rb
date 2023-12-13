# frozen_string_literal: true

class CeasedOrRevokedConfirmForm < WasteCarriersEngine::BaseForm
  delegate :contact_address, :company_name, :registration_type, :tier, to: :transient_registration
end
