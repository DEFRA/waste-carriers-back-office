# frozen_string_literal: true

module UsersHelper
  def display_user_actions?(displayed_user, current_user)
    current_user.can?(:modify_user, displayed_user)
  end
end
