# frozen_string_literal: true

class UserActivationsController < UserActivityController
  include UsersHelper

  private

  def user_activity_level_is_wrong?
    @user.active?
  end

  def perform_activation_action
    @user.activate!
  end
end
