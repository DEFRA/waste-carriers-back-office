# frozen_string_literal: true

module Notify
  class BaseSendEmailService < ::WasteCarriersEngine::BaseService
    include WasteCarriersEngine::ApplicationHelper
    include ActionView::Helpers::NumberHelper

    def run(registration:)
      @registration = registration

      client = Notifications::Client.new(WasteCarriersEngine.configuration.notify_api_key)

      client.send_email(notify_options)
    end

    private

    def validate_contact_email(registration)
      raise Exceptions::MissingContactEmailError, registration.reg_identifier unless registration.contact_email.present?

      assisted_digital_match = registration.contact_email == WasteCarriersEngine.configuration.assisted_digital_email

      raise Exceptions::AssistedDigitalContactEmailError, registration.reg_identifier if assisted_digital_match

      registration.contact_email
    end
  end
end
