# frozen_string_literal: true

class ContactEmailValidatorService < ::WasteCarriersEngine::BaseService
  def run(registration)
    raise Exceptions::MissingContactEmailError, registration.reg_identifier unless registration.contact_email.present?

    registration.contact_email
  end
end
