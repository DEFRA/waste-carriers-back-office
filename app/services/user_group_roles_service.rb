# frozen_string_literal: true

class UserGroupRolesService
  def self.call(user)
    if %w[cbd_user agency_with_refund].include?(user.role)
      ["data_agent"]
    elsif user.in_agency_group?
      User::AGENCY_ROLES
    elsif user.in_finance_group?
      User::FINANCE_ROLES
    else
      []
    end
  end
end
