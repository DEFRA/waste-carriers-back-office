# frozen_string_literal: true

class NotifyRenewalLetterPresenter < WasteCarriersEngine::BasePresenter
  include WasteCarriersEngine::ApplicationHelper

  MAX_SITE_DESCRIPTION_LENGTH = 200

  def contact_name
    "#{first_name} #{last_name}"
  end

  def expiry_date
    expires_on.to_formatted_s(:unpadded_day_month_year)
  end

  def registration_cost
    display_pence_as_pounds(Rails.configuration.new_registration_charge)
  end

  def renewal_cost
    display_pence_as_pounds(Rails.configuration.renewal_charge)
  end

  def renewal_url
    root_url = Rails.configuration.wcrs_renewals_url.split("//").last

    [root_url,
     "/fo/renew/",
     renew_token].join
  end
end
