# frozen_string_literal: true

class CopyCardsBankTransferForm < WasteCarriersEngine::BaseForm
  delegate :total_to_pay, to: :transient_registration

  def self.can_navigate_flexibly?
    false
  end
end
