# frozen_string_literal: true

class FinalReminderLettersBulkPdfService < ::WasteCarriersEngine::BaseService
  def run(registrations)
    return unless registrations.any?

    @registrations = registrations

    ApplicationController.new.render_to_string(
      pdf: true,
      template: "final_reminder_letters/bulk",
      disable_smart_shrinking: true,
      margin: { top: "20mm", bottom: "30mm", left: "20mm", right: "20mm" },
      page_size: "A4",
      print_media_type: true,
      layout: false,
      locals: locals
    )
  rescue StandardError => e
    Airbrake.notify e
    Rails.logger.error "Generate non-AD Final reminder letters PDF bulk error:\n#{e}"

    raise e
  end

  private

  def locals
    {
      presenters: presenters
    }
  end

  def presenters
    @registrations.map do |registration|
      # TODO: When template exists
      # FinalReminderLetterPresenter.new(registration)
      registration
    end
  end
end
