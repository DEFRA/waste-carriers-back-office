# frozen_string_literal: true

class PaymentMethodConfirmationFormsController < WasteCarriersEngine::PaymentMethodConfirmationFormsController
  include CanPauseCallRecording
  include CanAuthenticateUser

  # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :check_and_pause_call_recording, only: %i[new]
  # rubocop:enable Rails/LexicallyScopedActionFilter
end
