# frozen_string_literal: true

class DeviseCustomMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers

  def invitation_instructions(record, token, opts = {})
    send_via_gov_notify(:invitation_instructions, record, opts.merge(token: token))
  end

  def reset_password_instructions(record, token, opts = {})
    send_via_gov_notify(:reset_password_instructions, record, opts.merge(token: token))
  end

  def unlock_instructions(record, token, opts = {})
    send_via_gov_notify(:unlock_instructions, record, opts.merge(token: token))
  end

  private

  def send_via_gov_notify(template, record, opts)
    Notify::DeviseSender.run(template: template, record: record, opts: opts)
  end

  def invite_url(token)
    Rails.application.routes.url_helpers.accept_user_invitation_url(
      host: Rails.configuration.wcrs_back_office_url,
      invitation_token: token
    )
  end

  def service_link
    Rails.application.routes.url_helpers.root_url(host: Rails.configuration.wcrs_back_office_url)
  end
end
