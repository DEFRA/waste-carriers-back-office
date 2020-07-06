# frozen_string_literal: true

class FinalReminderLettersExportPresenter < ::WasteCarriersEngine::BasePresenter
  include ActionView::Helpers::TextHelper

  def downloadable?
    succeeded? && number_of_letters&.positive?
  end

  def expires_on_date
    @_expires_on_date ||= expires_on.to_formatted_s(:abbr_week_day_month)
  end

  def letters_label
    if number_of_letters.positive?
      pluralize(number_of_letters, I18n.t("final_reminder_letters_exports.index.table.letters_label"))
    else
      I18n.t("final_reminder_letters_exports.index.labels.no_registrations")
    end
  end

  def print_label
    return if failed?

    return printed_label if printed?
    return none_to_print_label if number_of_letters.zero?
  end

  private

  def printed_label
    I18n.t(
      "final_reminder_letters_exports.index.labels.printed",
      printed_by: printed_by_label,
      printed_on: printed_on.to_formatted_s(:abbr_week_day_month)
    )
  end

  def printed_by_label
    printed_by.scan(/(\A.*)[.|_](.*)@/).flatten.map(&:capitalize).join(" ").presence || printed_by
  end

  def none_to_print_label
    I18n.t("final_reminder_letters_exports.index.labels.none_to_print")
  end
end
