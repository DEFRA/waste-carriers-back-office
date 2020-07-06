# frozen_string_literal: true

module AdPrivacyPolicyHelper
  def link_to_privacy_policy
    path = File.join(Rails.configuration.wcrs_renewals_url, "/fo/pages/privacy")

    link_to(t(".privacy_policy"), path, target: "_blank")
  end
end
