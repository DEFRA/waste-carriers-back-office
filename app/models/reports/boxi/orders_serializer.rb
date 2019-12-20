# frozen_string_literal: true

module Reports
  module Boxi
    class OrdersSerializer < ::Reports::Boxi::BaseSerializer
      ATTRIBUTES = {
        uid: "RegistrationUID",
        order_uid: "OrderUID",
        order_code: "OrderCode",
        payment_method: "PaymentMethod",
        total_amount: "TotalCharge",
        description: "Description",
        merchant_id: "MerchantID",
        date_created: "CreationTimestamp",
        date_last_updated: "LastModifiedTimestamp",
        updated_by_user: "LastModifiedBy"
      }.freeze

      def add_entries_for(registration, uid)
        registration.finance_details.orders.each.with_index do |order, order_uid|
          csv << parse_order(order, uid, order_uid)
        end
      end

      private

      def parse_order(order, uid, order_uid)
        ATTRIBUTES.map do |key, _value|
          if key == :uid
            uid
          elsif key == :order_uid
            order_uid
          else
            order.public_send(key)
          end
        end
      end

      def file_name
        "orders.csv"
      end
    end
  end
end
