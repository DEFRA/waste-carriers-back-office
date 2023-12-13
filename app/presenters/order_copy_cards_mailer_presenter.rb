# frozen_string_literal: true

class OrderCopyCardsMailerPresenter < WasteCarriersEngine::BasePresenter
  def initialize(registration, copy_cards_order, view_context = nil)
    @copy_cards_order = copy_cards_order

    super(registration, view_context)
  end

  def contact_name
    @_contact_name ||= "#{first_name} #{last_name}"
  end

  def order_description
    @_order_description ||= order_item.description
  end

  def total_cards
    @_total_cards ||= order_item.quantity
  end

  def ordered_on_formatted_string
    @_ordered_on_formatted_string ||= copy_cards_order.date_created.to_datetime.to_fs(:day_month_year)
  end

  def total_paid
    @_total_paid ||= copy_cards_order.total_amount
  end
  alias payment_due total_paid

  private

  attr_reader :copy_cards_order

  def order_item
    @_order_item ||= copy_cards_order.order_items.first
  end
end
