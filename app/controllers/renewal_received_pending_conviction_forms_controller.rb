# frozen_string_literal: true

class RenewalReceivedPendingConvictionFormsController <
  WasteCarriersEngine::RenewalReceivedPendingConvictionFormsController
  include CanResumeCallRecording
  include CanAuthenticateUser

  before_action :check_and_resume_call_recording, only: %i[new]

end
