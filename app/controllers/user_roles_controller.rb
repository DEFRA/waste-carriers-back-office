# frozen_string_literal: true

class UserRolesController < ApplicationController
  include UsersHelper

  before_action :assign_user
  before_action :check_activation_permissions

  def edit; end

  def update
    redirect_to users_url
  end

  private

  def assign_user
    @user = User.find(params[:id])
  end

  def check_activation_permissions
    return if agency_with_permission?(@user, current_user) || finance_with_permission?(@user, current_user)

    raise CanCan::AccessDenied
  end
end
