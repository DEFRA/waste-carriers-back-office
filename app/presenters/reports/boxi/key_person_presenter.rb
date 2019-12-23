# frozen_string_literal: true

module Reports
  module Boxi
    class KeyPersonPresenter < WasteCarriersEngine::BasePresenter
      def flagged_for_review
        conviction_search_result&.match_result
      end

      def review_flag_timestamp
        conviction_search_result&.searched_at
      end
    end
  end
end
