# frozen_string_literal: true

module Notify
  class DigitalRenewalSmsService < ::WasteCarriersEngine::BaseService
    TEMPLATE_ID = "c23c1300-6d49-4310-bda6-99174ca0cd23"

    def run(registration:)
      @registration = NotifyRenewalPresenter.new(registration)

      client = Notifications::Client.new(WasteCarriersEngine.configuration.notify_api_key)
      client.send_sms(
        template_id: template,
        reference: @registration.reg_identifier,
        phone_number: @registration.phone_number,
        personalisation: personalisation
      )
    end

    private

    def template
      TEMPLATE_ID
    end

    def personalisation
      {
        expiry_date: @registration.expiry_date,
        reg_identifier: @registration.reg_identifier,
        renewal_cost: @registration.renewal_cost
      }
    end
  end
end