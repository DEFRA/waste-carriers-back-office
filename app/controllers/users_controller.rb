# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :manage_back_office_users, current_user
    @users = list_of_users.page params[:page]
  end

  private

  def list_of_users
    User.all.order_by(email: :asc)
  end
end
