# frozen_string_literal: true

class UserRolesController < ApplicationController
  include UsersHelper

  before_action :assign_user
  before_action :check_activation_permissions

  def edit; end

  def update
    if successful_role_change?
      redirect_to users_url
    else
      render :edit
    end
  end

  private

  def assign_user
    @user = User.find(params[:id])
    @old_role = User.find(@user.id).role
  end

  def check_activation_permissions
    return if current_user.can?(:modify_user, @user)

    raise CanCan::AccessDenied
  end

  def selected_role_is_valid?(role)
    current_user_group_roles(current_user).include?(role)
  end

  def successful_role_change?
    role = params.dig(:user, :role)
    selected_role_is_valid?(role) && @user.change_role(role)
  end
end
