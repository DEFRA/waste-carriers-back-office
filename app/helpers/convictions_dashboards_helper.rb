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
end
