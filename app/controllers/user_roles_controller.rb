# frozen_string_literal: true

class UserRolesController < ApplicationController
  include UsersHelper

  before_action :assign_user
  before_action :check_activation_permissions

  def edit; end

  def update
    if @user.change_role(params.dig(:user, :role))
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
    return if agency_with_permission?(@user, current_user) || finance_with_permission?(@user, current_user)

    raise CanCan::AccessDenied
  end
end
