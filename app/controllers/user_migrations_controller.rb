# frozen_string_literal: true

class UserMigrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize

  def new; end

  def create
    redirect_to user_migration_results_path
  end

  def results; end

  private

  def authorize
    authorize! :manage_back_office_users, current_user
  end
end
