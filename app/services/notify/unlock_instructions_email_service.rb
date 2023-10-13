# frozen_string_literal: true

module Notify
  class UnlockInstructionsEmailService < DeviseSender
    private

    def unlock_url(token)
      Rails.application.routes.url_helpers.user_unlock_url(
        host: Rails.configuration.wcrs_back_office_url,
        unlock_token: token
      )
    end

    def notify_options(record, opts)
      {
        email_address: record.email,
        template_id: "a3295516-26a6-4c01-9e3a-d5000f1a86c6",
        personalisation: {
          email_address: record.email,
          unlock_link: unlock_url(opts[:token])
        }
      }
    end
  end
end
