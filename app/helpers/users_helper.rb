# frozen_string_literal: true

module UsersHelper
  def display_user_actions?(displayed_user, current_user)
    agency_with_permission?(displayed_user, current_user) || finance_with_permission?(displayed_user, current_user)
  end

  private

  def agency_with_permission?(displayed_user, current_user)
    displayed_user.in_agency_group? && current_user.can?(:manage_agency_users, displayed_user)
  end

  def finance_with_permission?(displayed_user, current_user)
    displayed_user.in_finance_group? && current_user.can?(:manage_finance_users, displayed_user)
  end
end
