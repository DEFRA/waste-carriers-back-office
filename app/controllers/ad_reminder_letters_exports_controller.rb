# frozen_string_literal: true

class AdReminderLettersExportsController < ApplicationController
  def index
    authorize! :manage, ReminderLettersExport

    @ad_reminder_letters_exports_presenters = ad_reminder_letters_exports_presenters
  end

  def update
    ad_reminder_letters_export = AdReminderLettersExport.find(params[:id])

    ad_reminder_letters_export.update(ad_reminder_letters_export_attributes)

    redirect_to ad_reminder_letters_exports_path
  end

  private

  def ad_reminder_letters_export_attributes
    params.require(:ad_reminder_letters_export).permit(:printed_on, :printed_by)
  end

  def ad_reminder_letters_exports_presenters
    AdReminderLettersExport.not_deleted.map do |ad_reminder_letters_export|
      ReminderLettersExportPresenter.new(ad_reminder_letters_export)
    end
  end
end
