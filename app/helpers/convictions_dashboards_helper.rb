# frozen_string_literal: true

module ConvictionsDashboardsHelper
  def convictions_action_path(action)
    action_paths = {
      index: convictions_path,
      possible_matches: convictions_possible_matches_path,
      checks_in_progress: convictions_checks_in_progress_path,
      approved: convictions_approved_path,
      rejected: convictions_rejected_path
    }
    action_paths[action.to_sym]
  end

  def details_path(resource)
    if resource.is_a?(WasteCarriersEngine::Registration)
      registration_convictions_path(resource.reg_identifier)
    elsif resource.is_a?(WasteCarriersEngine::RenewingRegistration)
      transient_registration_convictions_path(resource.reg_identifier)
    end
  end
end
