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
      end
    end
  end
end
