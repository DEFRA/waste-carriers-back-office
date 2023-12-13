# frozen_string_literal: true

class OrderCopyCardsCompletionService < WasteCarriersEngine::BaseService
  attr_reader :transient_registration

  delegate :registration, to: :transient_registration

  def run(transient_registration)
    @transient_registration = transient_registration

    complete_order_copy_cards
  end

  private

  def complete_order_copy_cards
    # Called to get copy cards order before transient registration is deleted later
    cached_copy_cards_order

    update_registration

    delete_transient_registration

    send_confirmation_email unless @transient_registration.assisted_digital?
  end

  def update_registration
    WasteCarriersEngine::MergeFinanceDetailsService.call(transient_registration:, registration:)
    registration.save!

    # Log the order items only if payment is complete.
    if @transient_registration.unpaid_balance?
      # Orders paid using alternate payment methods are not currently
      # included in the card order export. Just log these.
      Rails.logger.warn("Copy card order payment incomplete " \
                        "for registration #{@transient_registration.reg_identifier}")
    else
      WasteCarriersEngine::OrderItemLog.create_from_registration(registration, Time.current)
    end
  end

  def delete_transient_registration
    transient_registration.delete
  end

  def send_confirmation_email
    if @transient_registration.unpaid_balance?
      Notify::CopyCardsAwaitingPaymentEmailService
        .run(registration: registration, order: cached_copy_cards_order)
    else
      Notify::CopyCardsOrderCompletedEmailService
        .run(registration: registration, order: cached_copy_cards_order)
    end
  rescue StandardError => e
    Airbrake.notify(e, registration_no: registration.reg_identifier) if defined?(Airbrake)
  end

  def cached_copy_cards_order
    @cached_copy_cards_order ||= transient_registration.reload.finance_details.orders.last
  end
end
