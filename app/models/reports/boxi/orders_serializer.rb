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
        return unless registration.finance_details.present?
        return unless registration.finance_details.orders.present?

        registration.finance_details.orders.each.with_index do |order, index|
          # Start counting from 1 rather than from 0
          order_uid = index + 1

          csv << parse_order(order, uid, order_uid)
        end
      end

      private

      def parse_order(order, uid, order_uid)
        presenter = OrderPresenter.new(order, nil)

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
        "orders.csv"
      end
    end
  end
end
