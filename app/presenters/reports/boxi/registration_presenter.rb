# frozen_string_literal: true

module Reports
  module Boxi
    class RegistrationPresenter < WasteCarriersEngine::BasePresenter
      include FinanceDetailsHelper

      delegate :status, :route, :revoked_reason, to: :metadata, prefix: true

      delegate :balance, to: :finance_details, prefix: true, allow_nil: true
      delegate :match_result, to: :conviction_search_result, prefix: true, allow_nil: true

      def finance_details_balance
        finance_details&.balance && display_pence_as_pounds_and_cents(finance_details.balance)
      end

      def metadata_date_registered
        return if metadata&.date_registered.blank?

        metadata.date_registered.to_datetime.to_fs(:calendar_date_and_local_time)
      end

      def metadata_date_activated
        return if metadata&.date_activated.blank?

        metadata.date_activated.to_datetime.to_fs(:calendar_date_and_local_time)
      end

      def expires_on
        return if super.blank?

        super.to_datetime.to_fs(:calendar_date_and_local_time)
      end

      def metadata_date_last_modified
        return if metadata&.last_modified.blank?

        metadata.last_modified.to_datetime.to_fs(:calendar_date_and_local_time)
      end

      def assistance_mode
        case metaData&.route
        when "DIGITAL"
          "Unassisted"
        when "PARTIALLY_ASSISTED_DIGITAL"
          "Partially assisted"
        when "ASSISTED_DIGITAL"
          "Fully assisted"
        else
          ""
        end
      end

      def conviction_search_result_searched_at
        return if conviction_search_result&.searched_at.blank?

        conviction_search_result.searched_at.to_datetime.to_fs(:calendar_date_and_local_time)
      end

      private

      def metadata
        @_metadata ||= metaData
      end
    end
  end
end
