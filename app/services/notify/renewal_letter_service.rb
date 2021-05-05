# frozen_string_literal: true

require "notifications/client"

module Notify
  class RenewalLetterService < ::WasteCarriersEngine::BaseService
    # So we can use displayable_address()
    include ::WasteCarriersEngine::ApplicationHelper

    def run(registration:)
      @registration = NotifyRenewalLetterPresenter.new(registration)

      client = Notifications::Client.new(WasteCarriersEngine.configuration.notify_api_key)

      client.send_letter(template_id: template,
                         personalisation: personalisation)
    end

    private

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
