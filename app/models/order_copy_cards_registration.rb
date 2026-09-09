# frozen_string_literal: true

class OrderCopyCardsRegistration < WasteCarriersEngine::TransientRegistration
  include CanUseOrderCopyCardsWorkflow
  include WasteCarriersEngine::CanUseLock

  validates :reg_identifier, "waste_carriers_engine/reg_identifier": true

  delegate :contact_address, :contact_email, :registered_address, to: :registration

  def registration
    return @registration if defined?(@registration)

    @registration = WasteCarriersEngine::Registration.find_by(reg_identifier: reg_identifier)
  end

  def prepare_for_payment(mode, user)
    BuildOrderCopyCardsFinanceDetailsService.run(
      cards_count: temp_cards,
      user: user,
      transient_registration: self,
      payment_method: mode
    )
  end
end
