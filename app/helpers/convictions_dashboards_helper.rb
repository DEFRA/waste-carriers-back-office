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
    case resource
    when WasteCarriersEngine::Registration
      registration_convictions_path(resource.reg_identifier)
    when WasteCarriersEngine::RenewingRegistration
      transient_registration_convictions_path(resource.reg_identifier)
    else
      raise StandardError, "Unsupported resource type #{resource.class}"
    end
  end
end
