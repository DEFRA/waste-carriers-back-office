# frozen_string_literal: true

require "csv"

module Reports
  class BaseCsvFileSerializer < BaseSerializer

    def initialize(path)
      @path = path

      super()
    end

    def to_csv(csv: nil, force_quotes: true)
      return fill_csv(csv) if csv

      CSV.open(@path, "w", force_quotes: force_quotes) do |csv_file|
        csv_file << self.class::ATTRIBUTES.values

        fill_csv(csv_file)

        yield csv_file if block_given?
      end
    rescue StandardError => e
      Rails.logger.error "Error writing CSV file to #{@path}: #{e}"
      Airbrake.notify(e, csv_file_path: @path)
    end

    def fill_csv(csv)
      each_data do |parsed_object|
        csv << parsed_object unless parsed_object.nil?
      end
    end

  end
end
