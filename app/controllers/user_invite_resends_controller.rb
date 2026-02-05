# frozen_string_literal: true

class UserInviteResendsController < ApplicationController
  before_action :authorize
  before_action :assign_user

  def new
    redirect_to users_url unless user_has_pending_invitation?
  end

  def create
    @user.invite! if user_has_pending_invitation?
    redirect_to users_url
  end

  private

  def authorize
    authorize! :manage_back_office_users, current_user
  end

  def assign_user
    @user = User.find(params[:user_id])
  end

  def user_has_pending_invitation?
    @user.invitation_token.present? && @user.invitation_accepted_at.nil?
  end
end
