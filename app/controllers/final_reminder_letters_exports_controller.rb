# frozen_string_literal: true

class FinalReminderLettersExportsController < ApplicationController
  def index
    authorize! :manage, ReminderLettersExport

    @final_reminder_letters_exports_presenters = final_reminder_letters_exports_presenters
  end

  def update
    final_reminder_letters_export = FinalReminderLettersExport.find(params[:id])

    final_reminder_letters_export.update(final_reminder_letters_export_attributes)

    redirect_to final_reminder_letters_exports_path
  end

  private

  def final_reminder_letters_export_attributes
    params.require(:final_reminder_letters_export).permit(:printed_on, :printed_by)
  end

  def final_reminder_letters_exports_presenters
    FinalReminderLettersExport.not_deleted.map do |final_reminder_letters_export|
      ReminderLettersExportPresenter.new(final_reminder_letters_export)
    end
  end
end
