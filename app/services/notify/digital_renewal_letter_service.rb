# frozen_string_literal: true

module Notify
  class DigitalRenewalLetterService < RenewalLetterService
    TEMPLATE_ID = "41ebbbc4-0d2f-425a-8d94-29e2beffd8ba"
    COMMS_LABEL = "Digital reminder letter"

    private

    def personalisation
      {
        contact_name: @registration.contact_name,
        expiry_date: @registration.expiry_date,
        reg_identifier: @registration.reg_identifier,
        registration_cost: @registration.registration_cost,
        renewal_cost: @registration.renewal_cost,
        renewal_url: @registration.renewal_url,
        user_email: @registration.contact_email,
        email_date: @registration.renewal_email_date
      }.merge(address_lines)
    end
  end
end
