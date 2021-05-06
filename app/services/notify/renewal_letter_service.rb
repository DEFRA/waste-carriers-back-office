# frozen_string_literal: true

require "notifications/client"

module Notify
  class RenewalLetterService < ::WasteCarriersEngine::BaseService
    include CanFormatAddress

    def run(registration:)
      @registration = NotifyRenewalLetterPresenter.new(registration)

      client = Notifications::Client.new(WasteCarriersEngine.configuration.notify_api_key)

      client.send_letter(template_id: template,
                         personalisation: personalisation)
    end
  end
end
