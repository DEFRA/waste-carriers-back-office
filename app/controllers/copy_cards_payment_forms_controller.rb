# frozen_string_literal: true

class CopyCardsPaymentFormsController < WasteCarriersEngine::CopyCardsPaymentFormsController
  include CanPauseCallRecording

  before_action :check_and_pause_call_recording, only: %i[new]
end
