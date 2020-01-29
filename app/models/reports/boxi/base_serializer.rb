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

      def sanitize(string)
        return unless string.respond_to?(:gsub)

        string.gsub("\n", ".")
      end
    end
  end
end
