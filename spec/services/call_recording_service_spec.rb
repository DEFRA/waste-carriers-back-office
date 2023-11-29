# frozen_string_literal: true

require "rails_helper"

RSpec.describe CallRecordingService do
  describe "#pause" do
    let(:email) { "test@example.com" }
    let(:call_recording_service) { described_class.new(user: user) }
    let(:user) { create(:user, storm_user_id: "12345", email: email) }

    before do
      allow(Rails.logger).to receive(:error)
    end

    context "when user has a storm_user_id" do
      before do
        allow(DefraRuby::Storm::PauseCallRecordingService).to receive(:run)
          .with(agent_user_id: user.storm_user_id)
          .and_return(instance_double(DefraRuby::Storm::RecordingResponse, result: described_class::SUCCESS_RESULT))
      end

      context "when pausing is successful" do
        it "returns true" do
          expect(call_recording_service.pause).to be(true)
        end
      end

      context "when pausing fails" do
        before do
          allow(DefraRuby::Storm::PauseCallRecordingService).to receive(:run).with(agent_user_id: user.storm_user_id)
                                                                             .and_return(instance_double(DefraRuby::Storm::RecordingResponse, result: "1"))
        end

        it "returns false" do
          expect(call_recording_service.pause).to be(false)
        end
      end
    end

    context "when user does not have a storm_user_id" do
      let(:user) { create(:user, storm_user_id: nil, email: email) }
      let(:fetched_storm_user_id) { "67890" }

      context "when fetching the storm_user_id succeeds" do
        before do
          allow(user).to receive(:update)
          allow(DefraRuby::Storm::UserDetailsService).to receive(:run)
            .with(username: user.email)
            .and_return(instance_double(DefraRuby::Storm::GetUserDetailsResponse, user_id: fetched_storm_user_id))
          allow(DefraRuby::Storm::PauseCallRecordingService).to receive(:run)
            .with(agent_user_id: fetched_storm_user_id)
            .and_return(instance_double(DefraRuby::Storm::RecordingResponse, result: described_class::SUCCESS_RESULT))
        end

        it "fetches storm_user_id and returns true" do
          expect(call_recording_service.pause).to be true
          expect(DefraRuby::Storm::UserDetailsService).to have_received(:run).with(username: user.email)
          expect(user).to have_received(:update).with(storm_user_id: fetched_storm_user_id)
        end
      end

      context "when fetching the storm_user_id fails" do
        before do
          allow(DefraRuby::Storm::UserDetailsService).to receive(:run)
            .with(username: user.email)
            .and_raise(DefraRuby::Storm::ApiError.new("API error"))
        end

        it "returns false" do
          expect(call_recording_service.pause).to be false
        end
      end
    end

    context "when there is an API error" do
      let(:api_error) { DefraRuby::Storm::ApiError.new("API error") }

      before do
        allow(DefraRuby::Storm::PauseCallRecordingService).to receive(:run).with(agent_user_id: user.storm_user_id)
                                                                           .and_raise(api_error)
      end

      it "logs the error and returns false" do
        call_recording_service.pause
        expect(Rails.logger).to have_received(:error).with("Error pausing call recording: #{api_error.message}")
      end
    end
  end

  describe "#resume" do
    let(:email) { "test@example.com" }
    let(:call_recording_service) { described_class.new(user: user) }
    let(:user) { create(:user, storm_user_id: "12345", email: email) }

    before do
      allow(Rails.logger).to receive(:error)
    end

    context "when user has a storm_user_id" do
      before do
        allow(DefraRuby::Storm::ResumeCallRecordingService).to receive(:run)
          .with(agent_user_id: user.storm_user_id)
          .and_return(instance_double(DefraRuby::Storm::RecordingResponse, result: described_class::SUCCESS_RESULT))
      end

      context "when resuming is successful" do
        it "returns true" do
          expect(call_recording_service.resume).to be(true)
        end
      end

      context "when resuming fails" do
        before do
          allow(DefraRuby::Storm::ResumeCallRecordingService).to receive(:run).with(agent_user_id: user.storm_user_id)
                                                                              .and_return(instance_double(DefraRuby::Storm::RecordingResponse, result: "1"))
        end

        it "returns false" do
          expect(call_recording_service.resume).to be(false)
        end
      end
    end

    context "when user does not have a storm_user_id" do
      let(:user) { create(:user, storm_user_id: nil, email: email) }
      let(:fetched_storm_user_id) { "67890" }

      context "when fetching the storm_user_id succeeds" do
        before do
          allow(user).to receive(:update)
          allow(DefraRuby::Storm::UserDetailsService).to receive(:run)
            .with(username: user.email)
            .and_return(instance_double(DefraRuby::Storm::GetUserDetailsResponse, user_id: fetched_storm_user_id))
          allow(DefraRuby::Storm::ResumeCallRecordingService).to receive(:run)
            .with(agent_user_id: fetched_storm_user_id)
            .and_return(instance_double(DefraRuby::Storm::RecordingResponse, result: described_class::SUCCESS_RESULT))
        end

        it "fetches storm_user_id and returns true" do
          expect(call_recording_service.resume).to be true
          expect(DefraRuby::Storm::UserDetailsService).to have_received(:run).with(username: user.email)
          expect(user).to have_received(:update).with(storm_user_id: fetched_storm_user_id)
        end
      end

      context "when fetching the storm_user_id fails" do
        before do
          allow(DefraRuby::Storm::UserDetailsService).to receive(:run)
            .with(username: user.email)
            .and_raise(DefraRuby::Storm::ApiError.new("API error"))
        end

        it "returns false" do
          expect(call_recording_service.resume).to be false
        end
      end
    end

    context "when there is an API error" do
      let(:api_error) { DefraRuby::Storm::ApiError.new("API error") }

      before do
        allow(DefraRuby::Storm::ResumeCallRecordingService).to receive(:run).with(agent_user_id: user.storm_user_id)
                                                                            .and_raise(api_error)
      end

      it "logs the error and returns false" do
        call_recording_service.resume
        expect(Rails.logger).to have_received(:error).with("Error resuming call recording: #{api_error.message}")
      end
    end
  end
end
