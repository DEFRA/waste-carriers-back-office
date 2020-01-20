# frozen_string_literal: true

class ConvictionImportsController < ApplicationController
  before_action :authorize

  def new; end

  def create
    add_flash_message
    redirect_to bo_path
  end

  private

  def authorize
    authorize! :import_conviction_data, current_user
  end

  def add_flash_message
    conviction_records_count = WasteCarriersEngine::ConvictionsCheck::Entity.count

    flash[:success] = I18n.t(
      "conviction_imports.flash_messages.successful",
      count: conviction_records_count
    )
  end
end
