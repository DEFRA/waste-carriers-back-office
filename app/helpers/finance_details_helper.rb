# frozen_string_literal: true

module FinanceDetailsHelper
  def display_pence_as_pounds_and_cents(pence)
    pounds = pence.to_f / 100

    format("%<pounds>.2f", pounds: pounds)
  end

  def details_path_for(resource)
    if resource.is_a?(WasteCarriersEngine::RenewingRegistration)
      renewing_registration_path(resource.reg_identifier)
    else
      registration_path(resource.reg_identifier)
    end
  end
end
