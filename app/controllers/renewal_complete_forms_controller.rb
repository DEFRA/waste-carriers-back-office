# frozen_string_literal: true

class RenewalCompleteFormsController < WasteCarriersEngine::RenewalCompleteFormsController
  include CanResumeCallRecording

  # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :check_and_resume_call_recording, only: %i[new]
  # rubocop:enable Rails/LexicallyScopedActionFilter
end
