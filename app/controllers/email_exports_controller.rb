# frozen_string_literal: true

class EmailExportsController < ApplicationController
  include CanSetFlashMessages

  before_action :authorize_user

  def show
    export_log = EmailExportLog.find(params[:id])
    export_log.download_log << { at: Time.zone.now, by: current_user.email }
    export_log.save!
    Rails.logger.info "\nRedirecting to #{export_log.download_link}\n"
    redirect_to URI.parse(export_log.download_link).to_s
  end

  def new
    # intentionally empty (SonarCloud)
  end

  def create
    batch_size = params[:batch_size].to_i

    if valid_batch_size?(batch_size)
      DeregistrationEmailExportService.run(batch_size)
      redirect_to new_email_exports_list_path
    else
      flash_error(I18n.t("email_exports.messages.error"),
                  I18n.t("email_exports.messages.invalid_batch_size"))
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def valid_batch_size?(batch_size)
    batch_size.is_a?(Integer) && batch_size.positive? && batch_size <= 100_000
  end

  def authorize_user
    authorize! :read, DeregistrationEmailExportService, current_user
  end
end
