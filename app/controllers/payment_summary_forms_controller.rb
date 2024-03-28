# frozen_string_literal: true

class PaymentSummaryFormsController < WasteCarriersEngine::PaymentSummaryFormsController
  include CanPauseCallRecording
  include CanAuthenticateUser

  before_action :check_and_pause_call_recording, only: %i[new]

end
