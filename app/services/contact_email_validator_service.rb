# frozen_string_literal: true

class ContactEmailValidatorService < ::WasteCarriersEngine::BaseService
  def run(registration)
    raise Exceptions::MissingContactEmailError, registration.reg_identifier if registration.contact_email.blank?

    registration.contact_email
  end
end
