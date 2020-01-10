# frozen_string_literal: true

class UserInvitationsController < Devise::InvitationsController
  before_action :authorize, only: %i[new create]
  before_action :configure_permitted_parameters

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
end
