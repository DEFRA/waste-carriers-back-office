# frozen_string_literal: true

module CanResumeCallRecording
  extend ActiveSupport::Concern

  def check_and_resume_call_recording
    return unless WasteCarriersEngine::FeatureToggle.active?(:control_call_recording)

    flash[:call_recording] = if call_recording_service.resume
                               { success: t("shared.call_recording_banner.call_resuming.success") }
                             else
                               { error: t("shared.call_recording_banner.call_resuming.error") }
                             end
  end

  private

  def resume_call_recording
    call_recording_service.resume
  end

  def call_recording_service
    @call_recording_service ||= CallRecordingService.new(user: current_user)
  end
end
