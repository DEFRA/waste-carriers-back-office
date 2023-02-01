# frozen_string_literal: true

class RenewalMagicLinkService < WasteCarriersEngine::BaseService
  def run(token:)
    [
      Rails.configuration.wcrs_fo_link_domain,
      "/fo/renew/",
      token
    ].join
  end
end
