# frozen_string_literal: true

class UserActivityController < ApplicationController
  include UsersHelper

  before_action :assign_user
  before_action :check_activation_permissions

  def new
    redirect_to users_url if user_activity_level_is_wrong?
  end

  def create
    perform_activation_action unless user_activity_level_is_wrong?
    redirect_to users_url
  end

  private

  def assign_user
    @user = User.find(params[:user_id])
  end

  def check_activation_permissions
    return if agency_with_permission?(@user, current_user) || finance_with_permission?(@user, current_user)

    raise CanCan::AccessDenied
  end
end
