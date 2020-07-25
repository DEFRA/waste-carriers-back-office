# frozen_string_literal: true

class RenewalMagicLinkService < ::WasteCarriersEngine::BaseService
  def run(token:)
    [
      Rails.configuration.wcrs_renewals_url,
      "/fo/renew/",
      token
    ].join
  end
end
