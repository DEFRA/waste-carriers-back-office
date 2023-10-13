# frozen_string_literal: true

module Notify
  class ResetPasswordInstructionsEmailService < DeviseSender
    private

    def reset_url(token)
      Rails.application.routes.url_helpers.edit_user_password_url(
        host: Rails.configuration.wcrs_back_office_url,
        reset_password_token: token
      )
    end

    def notify_options(record, opts)
      {
        email_address: record.email,
        template_id: "bfe66f5e-29ed-4f78-82e1-8baf5548f97a",
        personalisation: {
          email_address: record.email,
          reset_password_link: reset_url(opts[:token])
        }
      }
    end
  end
end
