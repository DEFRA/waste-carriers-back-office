# frozen_string_literal: true

module DashboardsHelper
  include WasteCarriersEngine::ApplicationHelper

  def inline_registered_address(result)
    address = displayable_address(result.registered_address)
    return nil if address.empty?

    address.join(", ")
  end
end
