# frozen_string_literal: true

# This class combines the form handling logic of WasteCarriersEngine::FormsController
# with the back-office security methods used by ApplicationController.
class BackOfficeFormsController < WasteCarriersEngine::FormsController
  include CanActAsBackOfficePage

  prepend_before_action :authenticate_user!
  before_action :authorize_user

end
