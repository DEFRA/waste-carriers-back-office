# frozen_string_literal: true

class RegistrationReceivedPendingConvictionFormsController <
      WasteCarriersEngine::RegistrationReceivedPendingConvictionFormsController
  include CanResumeCallRecording

  before_action :check_and_resume_call_recording, only: %i[new]

end
