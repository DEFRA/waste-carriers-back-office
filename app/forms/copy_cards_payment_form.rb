# frozen_string_literal: true

class CopyCardsPaymentForm < WasteCarriersEngine::BaseForm
  delegate :temp_payment_method, to: :transient_registration

  validates :temp_payment_method, inclusion: { in: %w[card bank_transfer] }
end
