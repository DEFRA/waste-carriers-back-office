# frozen_string_literal: true

class RegistrationCompletedFormsController < WasteCarriersEngine::RegistrationCompletedFormsController
  include CanResumeCallRecording
  include CanAuthenticateUser

  before_action :check_and_resume_call_recording, only: %i[new]

end
