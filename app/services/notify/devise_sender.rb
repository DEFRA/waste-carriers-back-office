# frozen_string_literal: true

module Notify
  class DeviseSender
    include WasteCarriersEngine::ApplicationHelper
    include ActionView::Helpers::NumberHelper

    def self.run(template:, record:, opts:)
      new.run(template: template, record: record, opts: opts)
    end

    def run(template:, record:, opts:)
      service_class = service_for_template(template)
      service = service_class.new

      service.send_email(record, opts)
    end

    def send_email(record, opts)
      client.send_email(notify_options(record, opts))
    end

    private

    def service_for_template(template)
      case template
      when :reset_password_instructions
        ResetPasswordInstructionsEmailService
      when :unlock_instructions
        UnlockInstructionsEmailService
      when :invitation_instructions
        InvitationInstructionsEmailService
      else
        raise ArgumentError, "Unknown email template: #{template}"
      end
    end

    def client
      @client ||= Notifications::Client.new(WasteCarriersEngine.configuration.notify_api_key)
    end
  end
end
