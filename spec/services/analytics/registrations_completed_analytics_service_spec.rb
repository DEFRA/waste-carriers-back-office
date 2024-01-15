# frozen_string_literal: true

require "rails_helper"

module Analytics
  RSpec.describe RegistrationsCompletedAnalyticsService do

    describe "#run" do
      subject(:service_result) { described_class.run(start_date:, end_date:) }

      let(:start_date) { 1.month.ago.to_date }
      let(:end_date) { Time.zone.today }

      before do
        # create one of each combination of traits
        %i[registration renewal].each do |journey_type|
          %w[DIGITAL ASSISTED_DIGITAL].each do |started_route|
            [start_date - 1.day, start_date, end_date, end_date + 1.day].each do |started_at|
              Timecop.freeze(started_at) do
                create(:user_journey, journey_type, :completed_digital, started_route:)
                create(:user_journey, journey_type, :completed_assisted_digital, started_route:)
                create(:user_journey, journey_type, completed_at: nil, started_route:)
              end
            end
          end
        end
      end

      # Expected: 2 dates in scope X (2 journey_types X (2 start_routes X 3 completion statuses)) => 24 in scope
      # of these, 12 each registration/renewal; of which 6 each started digital/assisted digital; 4 each for the three completion statuses
      it { expect(service_result[:registrations_started_digital]).to eq 6 }
      it { expect(service_result[:registrations_started_assisted_digital]).to eq 6 }
      it { expect(service_result[:registrations_completed]).to eq 8 }
      it { expect(service_result[:registrations_completed_digital]).to eq 4 }
      it { expect(service_result[:registrations_completed_assisted_digital]).to eq 4 }
      it { expect(service_result[:registrations_incomplete]).to eq 4 }

      it { expect(service_result[:renewals_started_digital]).to eq 6 }
      it { expect(service_result[:renewals_started_assisted_digital]).to eq 6 }
      it { expect(service_result[:renewals_completed]).to eq 8 }
      it { expect(service_result[:renewals_completed_digital]).to eq 4 }
      it { expect(service_result[:renewals_completed_assisted_digital]).to eq 4 }
      it { expect(service_result[:renewals_incomplete]).to eq 4 }

    end
  end
end
