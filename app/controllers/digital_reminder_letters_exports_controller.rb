# frozen_string_literal: true

class DigitalReminderLettersExportsController < ApplicationController
  def index
    authorize! :manage, ReminderLettersExport

    @digital_reminder_letters_exports_presenters = digital_reminder_letters_exports_presenters
  end

  def update
    digital_reminder_letters_export = DigitalReminderLettersExport.find(params[:id])

    digital_reminder_letters_export.update(digital_reminder_letters_export_attributes)

    redirect_to digital_reminder_letters_exports_path
  end

  private

  def digital_reminder_letters_export_attributes
    params.require(:digital_reminder_letters_export).permit(:printed_on, :printed_by)
  end

  def digital_reminder_letters_exports_presenters
    DigitalReminderLettersExport.not_deleted.map do |digital_reminder_letters_export|
      ReminderLettersExportPresenter.new(digital_reminder_letters_export)
    end
  end
end
