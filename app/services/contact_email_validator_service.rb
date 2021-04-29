# frozen_string_literal: true

class ContactEmailValidatorService < ::WasteCarriersEngine::BaseService
  def run(registration)
    raise Exceptions::MissingContactEmailError, registration.reg_identifier unless registration.contact_email.present?

    assisted_digital_match = registration.contact_email == WasteCarriersEngine.configuration.assisted_digital_email

    raise Exceptions::AssistedDigitalContactEmailError, registration.reg_identifier if assisted_digital_match

    registration.contact_email
  end
end
