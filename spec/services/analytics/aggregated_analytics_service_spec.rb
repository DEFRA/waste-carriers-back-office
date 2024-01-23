# frozen_string_literal: true

require "rails_helper"

module Analytics
  RSpec.describe AggregatedAnalyticsService do
    describe ".run" do
      subject(:result) { described_class.run(start_date: start_date, end_date: end_date) }

      let(:expected_structure) do
        {
          total_journeys_started: an_instance_of(Integer),
          back_office_started: an_instance_of(Integer),
          front_office_started: an_instance_of(Integer),
          total_journeys_completed: an_instance_of(Integer),
          completion_rate: an_instance_of(Float),
          front_office_completed: an_instance_of(Integer),
          back_office_completed: an_instance_of(Integer),
          cross_office_completed: an_instance_of(Integer),
          total_journeys_abandoned: an_instance_of(Integer)
        }
      end

      # default to getting past the location page
      let(:visited_pages) { %w[start_form location_form business_type_form] }

      context "with specific date range" do
        let(:start_date) { 7.days.ago }
        let(:end_date) { Time.zone.today }

        before do
          create_list(:user_journey, 5, :started_digital, visited_pages:, created_at: 5.days.ago, completed_at: nil)
          create_list(:user_journey, 3, :completed_digital, visited_pages:, created_at: 3.days.ago, completed_at: 2.days.ago)
          create_list(:user_journey, 2, :started_assisted_digital, visited_pages:, created_at: 4.days.ago, completed_at: nil)
          create(:user_journey, :started_digital, :completed_assisted_digital, visited_pages:, created_at: 2.days.ago, completed_at: 1.day.ago)
          create(:user_journey, visited_pages:, created_at: 8.days.ago, completed_at: 6.days.ago)
          create(:user_journey, visited_pages:, created_at: 6.days.ago, completed_at: 5.days.ago)

          # these should be excluded as the location page was not passed:
          create(:user_journey, created_at: 6.days.ago)
          create(:user_journey, visited_pages: %w[start_form], created_at: 6.days.ago)
          create(:user_journey, visited_pages: %w[start_form location_form], created_at: 6.days.ago)

          # these should be excluded as only NewRegistration and RenewingRegistration journeys should be counted:
          create(:user_journey, visited_pages:, created_at: 6.days.ago, journey_type: "EditRegistration")
          create(:user_journey, visited_pages:, created_at: 6.days.ago, journey_type: "Foo")
        end

        it { expect(result).to match(expected_structure) }
        it { expect(result[:total_journeys_started]).to eq(12) }
        it { expect(result[:back_office_started]).to eq(2) }
        it { expect(result[:front_office_started]).to eq(10) }
        it { expect(result[:total_journeys_completed]).to eq(5) }
        it { expect(result[:completion_rate]).to eq((5.0 / 12 * 100).round(2)) }
        it { expect(result[:front_office_completed]).to eq(3) }
        it { expect(result[:back_office_completed]).to eq(1) }
        it { expect(result[:cross_office_completed]).to eq(1) }
        it { expect(result[:total_journeys_abandoned]).to eq(7) }
      end

      context "with default date range" do
        subject(:result) { described_class.run }

        before do
          create(:user_journey, :started_digital, visited_pages:, created_at: 1.year.ago)
          create(:user_journey, :completed_digital, visited_pages:, created_at: 6.months.ago, completed_at: 5.months.ago)

          # this one should be excluded as the location page was not reached
          create(:user_journey, :started_digital, visited_pages: %w[start_form], created_at: 1.year.ago)

          # this one should be excluded as only new and renewing registration uer journeys should be counted
          create(:user_journey, :started_digital, visited_pages:, created_at: 1.year.ago, journey_type: "FooRegistration")
        end

        it { expect(result).to match(expected_structure) }
        it { expect(result[:total_journeys_started]).to eq(2) }
        it { expect(result[:back_office_started]).to eq(0) }
        it { expect(result[:front_office_started]).to eq(2) }
        it { expect(result[:total_journeys_completed]).to eq(1) }
        it { expect(result[:front_office_completed]).to eq(1) }
        it { expect(result[:back_office_completed]).to eq(0) }
        it { expect(result[:cross_office_completed]).to eq(0) }
        it { expect(result[:total_journeys_abandoned]).to eq(1) }
      end

      context "when no data is available for the date range" do
        let(:start_date) { 30.days.ago }
        let(:end_date) { 21.days.ago }

        before do
          create(:user_journey, visited_pages:, created_at: 31.days.ago)
          create(:user_journey, visited_pages:, created_at: 20.days.ago, completed_at: 5.days.ago)
        end

        it { expect(result).to match(expected_structure) }
        it { expect(result.values).to all(be_zero) }
      end
    end
  end
end
