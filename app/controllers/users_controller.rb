# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :manage_back_office_users, current_user

    @users = User.where(active: true).order_by(email: :asc).page(params[:page]).per(100)
  end

  def all
    authorize! :manage_back_office_users, current_user

    @users = User.all.order_by(email: :asc).page(params[:page]).per(100)

    @show_all_users = true
    render :index
  end
end
