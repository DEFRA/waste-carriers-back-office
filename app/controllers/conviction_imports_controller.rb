# frozen_string_literal: true

class ConvictionImportsController < ApplicationController
  before_action :authorize

  def new; end

  def create
    redirect_to bo_path
  end

  private

  def authorize
    authorize! :import_conviction_data, current_user
  end
end
