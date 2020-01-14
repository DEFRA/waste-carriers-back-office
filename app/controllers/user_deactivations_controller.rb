# frozen_string_literal: true

class UserDeactivationsController < UserActivityController
  include UsersHelper

  private

  def user_activity_level_is_wrong?
    @user.deactivated?
  end

  def perform_activation_action
    @user.deactivate!
  end
end
