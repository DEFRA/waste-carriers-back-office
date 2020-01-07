# frozen_string_literal: true

class UserActivationsController < ApplicationController
  include UsersHelper

  before_action :assign_user
  before_action :check_activation_permissions

  def activate_form
    redirect_to users_url if @user.active?
  end

  def deactivate_form
    redirect_to users_url unless @user.active?
  end

  def activate
    @user.activate! unless @user.active?
    redirect_to users_url
  end

  def deactivate
    @user.deactivate! if @user.active?
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
