# frozen_string_literal: true

module Analytics
  class AggregatedAnalyticsService < WasteCarriersEngine::BaseService
    attr_reader :start_date, :end_date

    def run(start_date: nil, end_date: nil)
      @start_date = start_date || default_start_date
      @end_date = end_date || Time.zone.today

      {
        total_journeys_started: total_journeys_started,
        total_journeys_completed: total_journeys_completed,
        completion_rate: completion_rate,
        front_office_started: front_office_started,
        back_office_started: back_office_started,
        front_office_completions: front_office_completions,
        back_office_completions: back_office_completions,
        cross_office_completions: cross_office_completions
      }
    end

    private

    def default_start_date
      WasteCarriersEngine::Analytics::UserJourney.minimum_created_at&.to_date.presence || Time.zone.today
    end

    def total_journeys_started
      WasteCarriersEngine::Analytics::UserJourney.date_range(start_date, end_date).count
    end

    def total_journeys_completed
      WasteCarriersEngine::Analytics::UserJourney.date_range(start_date, end_date).completed.count
    end

    def completion_rate
      return 0.0 if total_journeys_started.zero?

      (total_journeys_completed.to_f / total_journeys_started * 100).round(2)
    end

    def front_office_started
      WasteCarriersEngine::Analytics::UserJourney.date_range(start_date, end_date).started_digital.count
    end

    def back_office_started
      WasteCarriersEngine::Analytics::UserJourney.date_range(start_date, end_date).started_assisted_digital.count
    end

    def front_office_completions
      WasteCarriersEngine::Analytics::UserJourney.date_range(start_date, end_date).completed_digital.count
    end

    def back_office_completions
      WasteCarriersEngine::Analytics::UserJourney.date_range(start_date, end_date).completed_assisted_digital.count
    end

    def cross_office_completions
      WasteCarriersEngine::Analytics::UserJourney.date_range(start_date,
                                                             end_date).started_digital.completed_assisted_digital.count
    end
  end
end
