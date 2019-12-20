# frozen_string_literal: true

module Reports
  module Boxi
    class PaymentPresenter < WasteCarriersEngine::BasePresenter
      def date_received
        super&.to_datetime&.to_formatted_s(:calendar_date_and_local_time)
      end

      def date_entered
        super&.to_datetime&.to_formatted_s(:calendar_date_and_local_time)
      end
    end
  end
end
