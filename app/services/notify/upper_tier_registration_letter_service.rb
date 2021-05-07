# frozen_string_literal: true

require "notifications/client"

module Notify
  class UpperTierRegistrationLetterService < BaseLetterService
    private

    def template
      "92817aa7-6289-4837-a033-96d287644cb3"
    end

    def personalisation
      {
        contact_name: @registration.contact_name,
        registration_type: registration_type,
        reg_identifier: @registration.reg_identifier,
        company_name: @registration.company_name,
        registered_address: registered_address_string,
        phone_number: @registration.phone_number,
        date_registered: date_registered,
        expiry_date: @registration.expiry_date
      }.merge(address_lines)
    end

    def registration_type
      I18n.t("notify.letters.registration_type.upper.#{@registration.registration_type}")
    end

    def registered_address_string
      displayable_address(@registration.registered_address).join(", ")
    end

    def date_registered
      @registration.metaData.date_registered.in_time_zone("London").to_date.to_s
    end
  end
end
