# frozen_string_literal: true

module Reports
  module Boxi
    class OrderItemsSerializer < ::Reports::Boxi::BaseSerializer
      ATTRIBUTES = {
        uid: "RegistrationUID",
        order_uid: "OrderUID",
        type: "ItemType",
        amount: "ItemCharge",
        description: "Description",
        reference: "Reference",
        last_updated: "LastModifiedTimestamp"
      }.freeze

      def add_entries_for(registration, uid)
        return unless registration.finance_details.present?
        return unless registration.finance_details.orders.present?

        registration.finance_details.orders.each.with_index do |order, order_uid|
          next unless order.order_items.present?

          order.order_items.each do |order_item|
            csv << parse_order_item(order_item, uid, order_uid)
          end
        end
      end

      private

      def parse_order_item(order_item, uid, order_uid)
        presenter = OrderItemPresenter.new(order_item, nil)

        ATTRIBUTES.map do |key, _value|
          if key == :uid
            uid
          elsif key == :order_uid
            order_uid
          else
            sanitize(presenter.public_send(key))
          end
        end
      end

      def file_name
        "order_items.csv"
      end
    end
  end
end
