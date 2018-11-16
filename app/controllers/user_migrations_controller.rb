# frozen_string_literal: true

class UserMigrationsController < ApplicationController
  before_action :authenticate_user!

  def new
    authorize! :manage_back_office_users, current_user
  end

  def create
    authorize! :manage_back_office_users, current_user
    redirect_to users_path
  end
end
