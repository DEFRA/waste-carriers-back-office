# frozen_string_literal: true

class UserInvitationsController < Devise::InvitationsController
  before_action :configure_permitted_parameters

  private

  # This allows us to include a role on the user invitation form
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:invite, keys: [:role])
  end
end
