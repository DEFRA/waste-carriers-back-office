# frozen_string_literal: true

class OrderAndTotalPresenter < WasteCarriersEngine::BasePresenter
  LOCALES_KEY = ".shared.order_and_total"

  def order_items
    items = []

    transient_registration.finance_details.orders.first.order_items.each do |item|
      items << add_order_item(item)
    end

    items
  end

  def total_cost
    transient_registration.finance_details.balance
  end

  private

  def add_order_item(item)
    formatted_item = {}

    formatted_item[:amount] = item.amount
    formatted_item[:description] = description_for(item)

    formatted_item
  end

  def description_for(item)
    case item.type
    when WasteCarriersEngine::OrderItem::TYPES[:renew]
      description_for_renew
    when WasteCarriersEngine::OrderItem::TYPES[:edit]
      description_for_type_change
    when WasteCarriersEngine::OrderItem::TYPES[:copy_cards]
      description_for_copy_cards
    when WasteCarriersEngine::OrderItem::TYPES[:charge_adjust]
      description_for_charge_adjust
    else
      raise ArgumentError, "No description for #{item.type}"
    end
  end

  def description_for_renew
    I18n.t("#{LOCALES_KEY}.item_descriptions.renew")
  end

  def description_for_type_change
    if renewal?
      I18n.t("#{LOCALES_KEY}.item_descriptions.type_change.renewal")
    else
      I18n.t("#{LOCALES_KEY}.item_descriptions.type_change.edit")
    end
  end

  def description_for_copy_cards
    I18n.t("#{LOCALES_KEY}.item_descriptions.copy_cards", count: transient_registration.temp_cards)
  end

  def description_for_charge_adjust
    I18n.t("#{LOCALES_KEY}.item_descriptions.charge_adjust")
  end

  def renewal?
    transient_registration.is_a?(WasteCarriersEngine::RenewingRegistration)
  end
end
