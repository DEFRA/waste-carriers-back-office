# frozen_string_literal: true

module Reports
  module Boxi
    class SignOffPresenter < WasteCarriersEngine::BasePresenter
      def confirmed_at
        super&.to_datetime&.to_fs(:calendar_date_and_local_time)
      end
    end
  end
end
