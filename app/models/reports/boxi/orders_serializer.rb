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

      def add_entries_for(order, registration_uid, order_uid)
        csv << parse_order(order, registration_uid, order_uid)
      end

      private

      def parse_order(order, uid, order_uid)
        presenter = ::Reports::Boxi::OrderPresenter.new(order, nil)

        ATTRIBUTES.map do |key, _value|
          case key
          when :uid
            uid
          when :order_uid
            order_uid
          else
            sanitize(presenter.public_send(key))
          end
        end
      end

      def file_name
        "orders.csv"
      end
    end
  end
end
