# frozen_string_literal: true

class FinanceReportsController < ApplicationController
  include CanSetFlashMessages
  include CanListFilesOnAws

  before_action :authorize_user

  def show
    render :show, locals: { report_download_url: finance_report_download_url,
                            report_filename: finance_report_filename }
  end

  private

  def finance_report_download_url
    @finance_report_download_url ||= Reports::FinanceReportsAwsService.new.download_link
  end

  def finance_report_filename
    uri = URI.parse(finance_report_download_url)
    File.basename(uri.path)
  end

  def report_file_name
    File.basename(report_file_path)
  end

  def authorize_user
    authorize! :run_finance_reports, current_user
  end
end
