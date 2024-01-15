# frozen_string_literal: true

module Analytics
  class RegistrationsCompletedAnalyticsService < WasteCarriersEngine::BaseService

    attr_reader :start_date, :end_date

    scopes = %i[
      started_digital
      started_assisted_digital
      incomplete
      completed
      completed_digital
      completed_assisted_digital
    ]

    scopes.each do |scope|
      define_method("registrations_#{scope}") { count_journeys("registration", scope) }
      define_method("renewals_#{scope}") { count_journeys("renewal", scope) }
    end

    def run(start_date:, end_date:)
      @start_date = start_date
      @end_date = end_date

      {
        # registrations
        registrations_started_digital:,
        registrations_started_assisted_digital:,
        registrations_incomplete:,
        registrations_completed:,
        registrations_completed_digital:,
        registrations_completed_assisted_digital:,

        # renewals
        renewals_started_digital:,
        renewals_started_assisted_digital:,
        renewals_incomplete:,
        renewals_completed:,
        renewals_completed_digital:,
        renewals_completed_assisted_digital:
      }
    end

    private

    def count_journeys(journey_type, scope_name)
      WasteCarriersEngine::Analytics::UserJourney.date_range(start_date, end_date)
                                                 .send("#{journey_type}s")
                                                 .send(scope_name)
                                                 .count
    end
  end
end
