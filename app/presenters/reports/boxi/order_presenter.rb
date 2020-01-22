# frozen_string_literal: true

module Reports
  module Boxi
    class OrderPresenter < WasteCarriersEngine::BasePresenter
      def date_created
        super&.to_datetime&.to_formatted_s(:calendar_date_and_local_time)
      end

      def date_last_updated
        super&.to_datetime&.to_formatted_s(:calendar_date_and_local_time)
      end
    end
  end
end
