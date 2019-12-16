# frozen_string_literal: true

class UserActivationsController < ApplicationController
  def activate_form
    assign_user(params[:id])
    redirect_to users_url if @user.active?
  end

  def deactivate_form
    assign_user(params[:id])
    redirect_to users_url unless @user.active?
  end

  def activate
    assign_user(params[:id])
    @user.activate! unless @user.active?
    redirect_to users_url
  end

  def deactivate
    assign_user(params[:id])
    @user.deactivate! if @user.active?
    redirect_to users_url
  end

  private

  def assign_user(id)
    @user = User.find(id)
  end
end
