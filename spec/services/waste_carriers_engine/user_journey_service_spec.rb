# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  module Analytics
    RSpec.describe UserJourneyService do

      describe "#run" do
        subject(:run_service) { described_class.run(transient_registration:) }

        let(:page) { "start_form" }
        let(:route) { "DIGITAL" }
        let(:transient_registration) { create(:new_registration, :has_required_data) }
        let(:token) { transient_registration.token }
        let(:expected_journey_type) { "NewRegistration" }

        before do
          allow(WasteCarriersEngine.configuration).to receive(:host_is_back_office?).and_return false
          allow(UserJourney).to receive(:new).and_call_original
          allow(PageView).to receive(:new).and_call_original
        end

        context "when it runs in the back office" do
          before do
            allow(WasteCarriersEngine.configuration).to receive(:host_is_back_office?).and_return true

            described_class.run(transient_registration:)
          end

          it { expect(UserJourney.last.started_route).to eq "ASSISTED_DIGITAL" }
          it { expect(UserJourney.last.page_views.last.route).to eq "ASSISTED_DIGITAL" }
        end

        context "with a logged-in user" do
          let(:current_user) { build(:user) }

          it "stores the current user's email address on the user journey" do
            described_class.run(transient_registration:, current_user:)

            expect(UserJourney.last.user).to eq current_user.email
          end
        end
      end
    end
  end
end
