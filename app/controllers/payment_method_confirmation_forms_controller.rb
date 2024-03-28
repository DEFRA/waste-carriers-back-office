# frozen_string_literal: true

class PaymentMethodConfirmationFormsController < WasteCarriersEngine::PaymentMethodConfirmationFormsController
  include CanPauseCallRecording
  include CanAuthenticateUser

  before_action :check_and_pause_call_recording, only: %i[new]

end
