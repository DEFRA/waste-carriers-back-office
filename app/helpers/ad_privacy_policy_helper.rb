# frozen_string_literal: true

module AdPrivacyPolicyHelper
  def link_to_privacy_policy
    link_to(
      t(".privacy_policy_link_text"),
      URI.join(Rails.configuration.wcrs_fo_link_domain, "/fo/pages/privacy").to_s,
      target: "_blank", rel: "noopener"
    )
  end
end
