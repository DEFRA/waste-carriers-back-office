# frozen_string_literal: true

module Reports
  module Boxi
    class PaymentsSerializer < ::Reports::Boxi::BaseSerializer
      ATTRIBUTES = {
        uid: "RegistrationUID",
        order_key: "OrderKey",
        payment_type: "PaymentType",
        amount: "Amount",
        registration_reference: "Reference",
        comment: "Comment",
        date_received: "PaymentReceivedTimestamp",
        date_entered: "PaymentEnteredTimestamp",
        updated_by_user: "LastModifiedBy"
      }.freeze

      def add_entries_for(registration, uid)
        registration.finance_details.payments.each do |payment|
          csv << parse_payment(payment, uid)
        end
      end

      private

      def parse_payment(payment, uid)
        presenter = PaymentPresenter.new(payment, nil)

        ATTRIBUTES.map do |key, _value|
          if key == :uid
            uid
          else
            presenter.public_send(key)
          end
        end
      end

      def file_name
        "payments.csv"
      end
    end
  end
end
