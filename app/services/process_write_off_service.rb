# frozen_string_literal: true

class ProcessWriteOffService < WasteCarriersEngine::BaseService
  def run(finance_details:, user:, comment:)
    @finance_details = finance_details
    @user = user

    return false if finance_details.balance.zero?

    finance_details.payments << build_write_off(comment)

    finance_details.update_balance
    finance_details.save!
  end

  private

  attr_reader :user, :finance_details

  def build_write_off(comment)
    write_off = WasteCarriersEngine::Payment.new(payment_type: payment_type)

    write_off.order_key = SecureRandom.uuid.split("-").last
    write_off.amount = amount_to_write_off

    write_off.date_entered = Date.current
    write_off.date_received = Date.current
    write_off.registration_reference = payment_type
    write_off.updated_by_user = user.email
    write_off.comment = comment

    write_off
  end

  def amount_to_write_off
    return finance_details.zero_difference_balance if finance_details.unpaid_balance.positive?

    finance_details.zero_difference_balance * -1
  end

  def payment_type
    if user.can?(:write_off_large, finance_details)
      WasteCarriersEngine::Payment::WRITEOFFLARGE
    else
      WasteCarriersEngine::Payment::WRITEOFFSMALL
    end
  end
end
