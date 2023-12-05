# frozen_string_literal: true

module CanPauseCallRecording
  extend ActiveSupport::Concern

  def check_and_pause_call_recording
    return unless WasteCarriersEngine::FeatureToggle.active?(:control_call_recording)

    flash[:call_recording] = if call_recording_service.pause
                               { success: t("shared.call_recording_banner.call_pausing.success") }
                             else
                               { error: t("shared.call_recording_banner.call_pausing.error") }
                             end
  end

  # override this method which is in waste_carriers_engine/app/controllers/concerns/can_redirect_to_correct_form.rb
  # to fix bug which directs to /assets path when engine routes are not
  # specified
  def form_path
    basic_app_engine.send("new_#{@transient_registration.workflow_state}_path".to_sym,
                          token: @transient_registration.token)
  end

  private

  def pause_call_recording
    call_recording_service.pause
  end

  def call_recording_service
    @call_recording_service ||= CallRecordingService.new(user: current_user)
  end
end
