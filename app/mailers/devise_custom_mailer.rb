# frozen_string_literal: true

class DeviseCustomMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers

  def invitation_instructions(record, token, opts = {})
    WasteCarriersEngine::Notify::DeviseSender.run(template: :invitation_instructions,
                                                  record: record,
                                                  opts: opts.merge(
                                                    invite_link: invite_url(token),
                                                    invitation_due_at: record.invitation_due_at,
                                                    service_link:
                                                  ))
  end

  private

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
