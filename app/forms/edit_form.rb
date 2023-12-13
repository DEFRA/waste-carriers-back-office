# frozen_string_literal: true

class EditForm < WasteCarriersEngine::BaseForm
  after_initialize :persist_registration

  private

  def persist_registration
    transient_registration.save! unless transient_registration.persisted?
  end
end
