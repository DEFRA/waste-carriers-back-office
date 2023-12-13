# frozen_string_literal: true

class EditBankTransferForm < WasteCarriersEngine::BaseForm
  def self.can_navigate_flexibly?
    false
  end
end
