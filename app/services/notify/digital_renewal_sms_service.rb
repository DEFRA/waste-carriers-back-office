# frozen_string_literal: true

module Notify
  class DigitalRenewalSmsService < ::WasteCarriersEngine::BaseService
    include WasteCarriersEngine::CanRecordCommunication

    TEMPLATE_ID = "c23c1300-6d49-4310-bda6-99174ca0cd23"
    NOTIFICATION_TYPE = "sms"
    COMMS_LABEL = "Digital reminder text"

    def run(registration:)
      @registration = NotifyRenewalPresenter.new(registration)

      client = Notifications::Client.new(WasteCarriersEngine.configuration.notify_api_key)
      client.send_sms(
        template_id: template_id,
        reference: @registration.reg_identifier,
        phone_number: @registration.phone_number,
        personalisation: personalisation
      ).tap do |response|
        create_communication_record if response.instance_of?(Notifications::Client::ResponseNotification)
      end
    end

    def template_id
      TEMPLATE_ID
    end

    def notification_type
      NOTIFICATION_TYPE
    end

    def comms_label
      COMMS_LABEL
    end

    private

    def personalisation
      {
        expiry_date: @registration.expiry_date,
        reg_identifier: @registration.reg_identifier,
        renewal_cost: @registration.renewal_cost
      }
    end
  end
end
