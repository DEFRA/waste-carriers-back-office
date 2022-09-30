# frozen_string_literal: true

module AdPrivacyPolicyHelper
  def link_to_privacy_policy
    link_to(
      t(".privacy_policy_link_text"),
      URI.join(Rails.configuration.wcrs_renewals_url, "/fo/pages/privacy").to_s,
      target: "_blank", rel: "noopener"
    )
  end
end
