# frozen_string_literal: true

module Reports
  module Boxi
    class KeyPersonPresenter < WasteCarriersEngine::BasePresenter
      def flagged_for_review
        conviction_search_result&.match_result
      end

      def review_flag_timestamp
        conviction_search_result&.searched_at&.to_datetime&.to_formatted_s(:calendar_date_and_local_time)
      end

      def date_of_birth
        dob&.strftime("%d/%m/%Y")
      end
    end
  end
end
