# frozen_string_literal: true

# rubocop:disable Rails/HelperInstanceVariable
module UsersHelper
  def display_user_actions?(displayed_user, current_user)
    current_user.can?(:modify_user, displayed_user)
  end

  def current_user_group_roles(current_user)
    UserGroupRolesService.call(current_user)
  end

  private

  def assign_user
    @user = User.find(params[:user_id])
  end

  def check_modification_permissions
    return if current_user.can?(:modify_user, @user)

    raise CanCan::AccessDenied
  end

  def selected_role_is_in_allowed_group?(role)
    current_user_group_roles(current_user).include?(role)
  end
end
# rubocop:enable Rails/HelperInstanceVariable
