# frozen_string_literal: true

class FinanceReportsController < ApplicationController
  include CanSetFlashMessages

  before_action :authorize_user

  def show
    finance_reports_service.run

    send_file finance_reports_service.report_file_path, type: "text/html", disposition: "attachment"
  rescue StandardError => e
    Airbrake.notify e
    Rails.logger.error "Error generating financial reports file:\n#{e}\n#{e.backtrace}"
    flash.now[:error] = I18n.t("download_finance_reports.messages.failure")
  end

  private

  def finance_reports_service
    @finance_reports_service ||= Reports::FinanceReportsService.new
  end

  def report_file_path
    @report_file_path ||= finance_reports_service.report_file_path
  end

  def report_file_name
    File.basename(report_file_path)
  end

  def authorize_user
    authorize! :run_finance_reports, current_user
  end
end
