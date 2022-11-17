# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :manage_back_office_users, current_user

    @users = User.where(active: true).order_by(email: :asc).page(params[:page]).per(100)
  end

  def all
    authorize! :manage_back_office_users, current_user

    respond_to do |format|
      format.html do
        @users = User.all.order_by(email: :asc).page(params[:page]).per(100)
        @show_all_users = true
        render :index
      end

      format.csv do
        send_data Reports::UserExportSerializer.new.to_csv, filename: "users.csv"
      end
    end
  end
end
