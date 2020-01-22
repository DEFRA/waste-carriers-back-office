# frozen_string_literal: true

module Reports
  module Boxi
    class OrderItemPresenter < WasteCarriersEngine::BasePresenter
      include FinanceDetailsHelper

      def last_updated
        super&.to_datetime&.to_formatted_s(:calendar_date_and_local_time)
      end

      def amount
        super && display_pence_as_pounds_and_cents(super)
      end
    end
  end
end
