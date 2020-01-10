# frozen_string_literal: true

class UserActivityController < ApplicationController
  include UsersHelper

  before_action :assign_user
  before_action :check_modification_permissions

  def new
    redirect_to users_url if user_activity_level_is_wrong?
  end

  def create
    perform_activation_action unless user_activity_level_is_wrong?
    redirect_to users_url
  end
end
