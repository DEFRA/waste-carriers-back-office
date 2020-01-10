# frozen_string_literal: true

class UserInvitationsController < Devise::InvitationsController
  include UsersHelper

  before_action :authorize, only: %i[new create]
  before_action :configure_permitted_parameters

  def create
    if selected_role_is_valid?(params.dig(:user, :role))
      super
    else
      new
    end
  end

  private

  def authorize
    authorize! :manage_back_office_users, current_user
  end

  # This allows us to include a role on the user invitation form
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: [:role])
  end

  def after_invite_path_for(_resource)
    users_path
  end

  def selected_role_is_valid?(role)
    current_user_group_roles(current_user).include?(role)
  end
end
