# frozen_string_literal: true

module Reports
  module Boxi
    class KeyPersonPresenter < WasteCarriersEngine::BasePresenter
      def flagged_for_review
        return unless conviction_search_result

        conviction_search_result.match_result
      end

      def review_flag_timestamp
        return unless conviction_search_result

        conviction_search_result.searched_at
      end
    end
  end
end
