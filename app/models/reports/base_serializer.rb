# frozen_string_literal: true

require "csv"

module Reports
  class BaseSerializer
    def to_csv(force_quotes: true)
      CSV.generate(force_quotes: force_quotes) do |csv|
        csv << self.class::ATTRIBUTES.values

        each_data do |parsed_object|
          csv << parsed_object
        end
      end
    end

    private

    def each_data
      scope.each do |object|
        yield parse_object(object)
      rescue StandardError => e
        # Handle parsing errors here so that the serializer can continue with the next object.
        message = if object.respond_to?(:reg_identifier)
                    "Error mapping object with reg_identifier \"#{object.reg_identifier}\" to CSV: #{e}"
                  else
                    "Error writing CSV file to #{@path}: #{e}"
                  end

        Rails.logger.error message
        Airbrake.notify(e, message:, csv_file_path: @path)
      end
    end
  end
end
