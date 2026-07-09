# frozen_string_literal: true

module Notify
  class DigitalRenewalSmsService < ::WasteCarriersEngine::BaseService
    include WasteCarriersEngine::CanRecordCommunication

    TEMPLATE_ID = "ac9cfef1-28e3-4f24-8807-82136945c604"
    NOTIFICATION_TYPE = "sms"
    COMMS_LABEL = "Digital reminder text"

    def run(registration:)
      @registration = NotifyRenewalPresenter.new(registration)

      client = Notifications::Client.new(WasteCarriersEngine.configuration.notify_api_key)
      send_with_communication_record(client, :send_sms,
                                     template_id: template_id,
                                     reference: @registration.reg_identifier,
                                     phone_number: @registration.phone_number,
                                     personalisation: personalisation)
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
