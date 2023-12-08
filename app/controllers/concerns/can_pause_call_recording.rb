# frozen_string_literal: true

module CanPauseCallRecording
  extend ActiveSupport::Concern

  def check_and_pause_call_recording
    return unless WasteCarriersEngine::FeatureToggle.active?(:control_call_recording)
    return if bacs_payment_confirmation_page?

    flash[:call_recording] = if call_recording_service.pause
                               { success: t("shared.call_recording_banner.call_pausing.success") }
                             else
                               { error: t("shared.call_recording_banner.call_pausing.error") }
                             end
  end

  def bacs_payment_confirmation_page?
    return false unless request.path.include?("payment-method-confirmation")

    @transient_registration.temp_payment_method == "bank_transfer"
  end

  private

  def pause_call_recording
    call_recording_service.pause
  end

  def call_recording_service
    @call_recording_service ||= CallRecordingService.new(user: current_user)
  end
end
