# frozen_string_literal: true

module DashboardsHelper
  include WasteCarriersEngine::ApplicationHelper

  def inline_registered_address(result)
    address = displayable_address(result.registered_address)

    return if address.empty?

    address.join(", ")
  end

  def result_type(result)
    return "renewal" if result.is_a?(WasteCarriersEngine::TransientRegistration)
  end

  def status_tags(result)
    StatusTagService.run(resource: result)
  end

  def result_date(result)
    return if deactivated?(result)

    return expired_date(result) if result.expired?
    return will_expire_date(result) if result.is_a?(WasteCarriersEngine::Registration)

    last_modified_date(result)
  end

  private

  def deactivated?(result)
    result.inactive? || result.refused? || result.revoked?
  end

  def expired_date(result)
    formatted_date(:expired, result.expires_on)
  end

  def will_expire_date(result)
    formatted_date(:will_expire, result.expires_on)
  end

  def last_modified_date(result)
    formatted_date(:last_modified, result.metaData.last_modified)
  end

  def formatted_date(text, date)
    date = date.in_time_zone("London").to_formatted_s(:day_month_year_slashes)
    I18n.t(".dashboards.index.results.date.#{text}", date: date)
  end
end
