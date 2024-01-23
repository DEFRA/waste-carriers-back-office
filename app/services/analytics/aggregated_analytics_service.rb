# frozen_string_literal: true

module Analytics
  class AggregatedAnalyticsService < WasteCarriersEngine::BaseService
    attr_reader :start_date, :end_date

    def run(start_date: nil, end_date: nil)
      @start_date = start_date || default_start_date
      @end_date = end_date || Time.zone.today

      {
        total_journeys_started:,
        total_journeys_completed:,
        completion_rate:,
        front_office_started:,
        back_office_started:,
        front_office_completed:,
        back_office_completed:,
        cross_office_completed:,
        total_journeys_abandoned:
      }
    end

    private

    def default_start_date
      WasteCarriersEngine::Analytics::UserJourney.minimum_created_at&.to_date.presence || Time.zone.today
    end

    def front_office_started
      journey_base_scope.passed_start_cutoff_page
                        .started_digital
                        .count
    end

    def back_office_started
      journey_base_scope.passed_start_cutoff_page
                        .started_assisted_digital
                        .count
    end

    def total_journeys_started
      journey_base_scope.passed_start_cutoff_page
                        .count
    end

    def front_office_completed
      journey_base_scope.completed_digital
                        .count
    end

    def back_office_completed
      journey_base_scope.completed_assisted_digital
                        .count
    end

    def cross_office_completed
      journey_base_scope.started_digital
                        .completed_assisted_digital
                        .count
    end

    def total_journeys_completed
      journey_base_scope.completed
                        .count
    end

    def journey_base_scope
      WasteCarriersEngine::Analytics::UserJourney.only_types(%w[NewRegistration RenewingRegistration])
                                                 .date_range(start_date, end_date)
    end

    def total_journeys_abandoned
      total_journeys_started - total_journeys_completed
    end

    def completion_rate
      return 0.0 if total_journeys_started.zero?

      (total_journeys_completed.to_f / total_journeys_started * 100).round(2)
    end
  end
end
