# frozen_string_literal: true

class ConvictionImportsController < ApplicationController
  before_action :authorize

  def new; end

  def create
    if data_updated_successfully?
      add_success_flash_message
      redirect_to bo_path
    else
      render :new
    end
  end

  private

  def authorize
    authorize! :import_conviction_data, current_user
  end

  def data_updated_successfully?
    ConvictionImportService.run(params[:data])
    true
  rescue StandardError => e
    add_error_flash_message(e)
    false
  end

  def add_success_flash_message
    conviction_records_count = WasteCarriersEngine::ConvictionsCheck::Entity.count

    flash[:success] = I18n.t(
      "conviction_imports.flash_messages.successful",
      count: conviction_records_count
    )
  end

  def add_error_flash_message(error)
    flash[:error] = I18n.t(
      "conviction_imports.flash_messages.error",
      error: error
    )
  end
end
