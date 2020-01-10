# frozen_string_literal: true

class UserRolesController < ApplicationController
  include UsersHelper

  before_action :assign_user
  before_action :assign_old_role
  before_action :check_modification_permissions

  def new; end

  def create
    if successful_role_change?
      redirect_to users_url
    else
      render :new
    end
  end

  private

  def assign_old_role
    @old_role = User.find(@user.id).role
  end

  def selected_role_is_valid?(role)
    current_user_group_roles(current_user).include?(role)
  end

  def successful_role_change?
    role = params.dig(:user, :role)
    selected_role_is_valid?(role) && @user.change_role(role)
  end
end
