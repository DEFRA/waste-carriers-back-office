# frozen_string_literal: true

class CardOrderExportPresenter < WasteCarriersEngine::BasePresenter
  def initialize(export)
    @export = export

    super(export)
  end

  def self.create_from_collection(exports)
    exports.map do |export|
      new(export)
    end
  end

  def exported_at
    @export.exported_at.try(:strftime, Time::DATE_FORMATS[:year_month_day_hour_minutes_hyphens])
  end

  def first_downloaded_by
    @export.first_visited_by
  end

  def first_downloaded_at
    @export.first_visited_at.try(:strftime, Time::DATE_FORMATS[:year_month_day_hour_minutes_hyphens])
  end

end
