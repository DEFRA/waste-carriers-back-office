# frozen_string_literal: true

module Notify
  class AdRenewalLetterService < RenewalLetterService
    private

    def template
      "1b56d3a7-f7fd-414d-a3ba-2b50f627cf40"
    end

    def personalisation
      {
        contact_name: @registration.contact_name,
        expiry_date: @registration.expiry_date,
        reg_identifier: @registration.reg_identifier,
        registration_cost: @registration.registration_cost,
        renewal_cost: @registration.renewal_cost,
        renewal_url: @registration.renewal_url
      }.merge(address_lines)
    end
  end
end
