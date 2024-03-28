# frozen_string_literal: true

module CanResumeCallRecording
  extend ActiveSupport::Concern

  def check_and_resume_call_recording
    return unless should_resume_call_recording?

    resume_call_recording
  end

  private

  def should_resume_call_recording?
    WasteCarriersEngine::FeatureToggle.active?(:control_call_recording) &&
      !@transient_registration.lower_tier?
  end

  def resume_call_recording
    flash[:call_recording] = if call_recording_service.resume
                               { success: t("shared.call_recording_banner.call_resuming.success") }
                             else
                               { error: t("shared.call_recording_banner.call_resuming.error") }
                             end
  end

  def call_recording_service
    @call_recording_service ||= CallRecordingService.new(user: current_user)
  end
end
