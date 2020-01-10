# frozen_string_literal: true

module UsersHelper
  def display_user_actions?(displayed_user, current_user)
    current_user.can?(:modify_user, displayed_user)
  end

  def current_user_group_roles(current_user)
    if current_user.in_agency_group?
      User::AGENCY_ROLES
    elsif current_user.in_finance_group?
      User::FINANCE_ROLES
    end
  end
end
