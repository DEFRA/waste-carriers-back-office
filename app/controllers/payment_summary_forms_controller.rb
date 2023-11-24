# frozen_string_literal: true

class PaymentSummaryFormsController < WasteCarriersEngine::PaymentSummaryFormsController
  include CanPauseCallRecording

  before_action :check_and_pause_call_recording, only: %i[new]
end
