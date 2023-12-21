# frozen_string_literal: true

class ConvictionImportsController < ApplicationController
  include CanSetFlashMessages

  before_action :authorize

  def new; end

  def create
    uploaded_file = params[:file]
    if uploaded_file && File.extname(uploaded_file.original_filename).casecmp(".csv").zero?
      begin
        ConvictionImportService.run(uploaded_file.read)
        add_success_flash_message
        redirect_to bo_path
      rescue StandardError => e
        add_error_flash_message(e)
        render :new
      end
    else
      flash[:error] = I18n.t("conviction_imports.flash_messages.error")
      flash[:error_details] = I18n.t("conviction_imports.flash_messages.invalid_file_type_details")
      render :new
    end
  end

  private

  def authorize
    authorize! :import_conviction_data, current_user
  end

  def add_success_flash_message
    conviction_records_count = WasteCarriersEngine::ConvictionsCheck::Entity.count

    flash_success(
      I18n.t("conviction_imports.flash_messages.successful", count: conviction_records_count)
    )
  end

  def add_error_flash_message(error)
    flash_error(
      I18n.t("conviction_imports.flash_messages.error", error: error), nil
    )
  end
end
