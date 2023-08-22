class UserGroupRolesService
  def self.call(user, context: nil)
    if user.role == "agency_with_refund" && context == :invite
      ["data_agent"]
    elsif user.role == "cbd_user"
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
