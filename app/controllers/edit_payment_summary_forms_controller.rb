# frozen_string_literal: true

class EditPaymentSummaryFormsController < WasteCarriersEngine::EditPaymentSummaryFormsController
  include CanPauseCallRecording

  before_action :check_and_pause_call_recording, only: %i[new]
end
