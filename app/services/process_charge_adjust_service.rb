# frozen_string_literal: true

class ProcessChargeAdjustService < WasteCarriersEngine::BaseService
  def run(finance_details:, form:, user:)
    @form = form
    @user = user

    finance_details.orders << build_order

    finance_details.update_balance
    finance_details.save!
  end

  private

  attr_reader :form, :user

  def build_order
    order_item = WasteCarriersEngine::OrderItem.new_charge_adjust_item

    order_item.amount = form.amount
    order_item.description = form.description
    order_item.reference = form.reference

    order = WasteCarriersEngine::Order.new_order_for(user)

    order.description = form.description
    order.total_amount = form.amount
    order.payment_method = "UNKNOWN"
    order.merchant_id = "n/a"

    order.order_items = [order_item]

    order
  end
end
