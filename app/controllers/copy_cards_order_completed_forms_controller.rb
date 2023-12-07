# frozen_string_literal: true

class CopyCardsOrderCompletedFormsController < WasteCarriersEngine::CopyCardsOrderCompletedFormsController
  include CanResumeCallRecording
  include CanAuthenticateUser

  # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :check_and_resume_call_recording, only: %i[new]
  # rubocop:enable Rails/LexicallyScopedActionFilter
end
