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
    I18n.t(".dashboards.index.results.date.expired", date: result.expires_on
                                                                 .in_time_zone("London")
                                                                 .strftime("%d/%m/%Y"))
  end

  def will_expire_date(result)
    I18n.t(".dashboards.index.results.date.will_expire", date: result.expires_on
                                                                     .in_time_zone("London")
                                                                     .strftime("%d/%m/%Y"))
  end

  def last_modified_date(result)
    I18n.t(".dashboards.index.results.date.last_modified", date: result.metaData
                                                                       .last_modified
                                                                       .in_time_zone("London")
                                                                       .strftime("%d/%m/%Y"))
  end
end
