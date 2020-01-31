# frozen_string_literal: true

require "csv"

module Reports
  module Boxi
    class BaseSerializer
      delegate :close, to: :csv

      def initialize(destination_dir)
        @destination_dir = destination_dir
      end

      private

      attr_reader :destination_dir

      def csv
        @_csv ||= open_csv
      end

      def open_csv
        file_path = File.join(destination_dir, file_name)
        csv = CSV.open(file_path, "w+", force_quotes: true)

        # Add headers
        csv << self.class::ATTRIBUTES.values

        csv
      end

      # This is designed to handle the different types of newline we may find
      # in a string we are looking to export to a CSV file. For example we
      # need to go from something like this
      #
      #    "regsitered in error!\r\nAG See Pat for info. "
      #
      # to this
      #
      #    "regsitered in error! AG See Pat for info."
      #
      def sanitize(string)
        return unless string.respond_to?(:squish)

        string.squish
      end
    end
  end
end
