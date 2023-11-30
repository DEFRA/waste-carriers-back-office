# frozen_string_literal: true

class PaymentSummaryFormsController < WasteCarriersEngine::PaymentSummaryFormsController
  include CanPauseCallRecording

  # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :check_and_pause_call_recording, only: %i[new]
  # rubocop:enable Rails/LexicallyScopedActionFilter
end
