# frozen_string_literal: true

class EditCancellationService < WasteCarriersEngine::BaseService
  def run(edit_registration:)
    edit_registration.delete
  end
end
