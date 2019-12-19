# frozen_string_literal: true

class UserActivationsController < ApplicationController
  include UsersHelper

  def activate_form
    assign_user(params[:id])
    check_activation_permissions
    redirect_to users_url if @user.active?
  end

  def deactivate_form
    assign_user(params[:id])
    check_activation_permissions
    redirect_to users_url unless @user.active?
  end

  def activate
    assign_user(params[:id])
    check_activation_permissions
    @user.activate! unless @user.active?
    redirect_to users_url
  end

  def deactivate
    assign_user(params[:id])
    check_activation_permissions
    @user.deactivate! if @user.active?
    redirect_to users_url
  end

  private

  def assign_user(id)
    @user = User.find(id)
  end

  def check_activation_permissions
    return if agency_with_permission?(@user, current_user) || finance_with_permission?(@user, current_user)

    raise CanCan::AccessDenied
  end
end
