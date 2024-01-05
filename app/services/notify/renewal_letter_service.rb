# frozen_string_literal: true

require "notifications/client"

module Notify
  class RenewalLetterService < ::WasteCarriersEngine::BaseService
    NOTIFICATION_TYPE = "letter"
    # So we can use displayable_address()
    include ::WasteCarriersEngine::ApplicationHelper
    include WasteCarriersEngine::CanRecordCommunication

    def run(registration:)
      @registration = NotifyRenewalPresenter.new(registration)

      client = Notifications::Client.new(WasteCarriersEngine.configuration.notify_api_key)

      client.send_letter(template_id: template_id,
                         reference: @registration.reg_identifier,
                         personalisation: personalisation).tap do |response|
                           if response.instance_of?(Notifications::Client::ResponseNotification)
                             create_communication_record
                           end
                         end
    end

    private

    def template_id
      self.class::TEMPLATE_ID
    end

    def comms_label
      self.class::COMMS_LABEL
    end

    def notification_type
      NOTIFICATION_TYPE
    end

    def address_lines
      address_values = [
        @registration.contact_name,
        displayable_address(@registration.contact_address)
      ].flatten

      address_hash = {}

      address_values.each_with_index do |value, index|
        line_number = index + 1
        address_hash["address_line_#{line_number}"] = value
      end

      address_hash
    end
  end
end
