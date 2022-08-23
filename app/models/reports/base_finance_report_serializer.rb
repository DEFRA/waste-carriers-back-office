# frozen_string_literal: true

module Reports
  class BaseFinanceReportSerializer < BaseSerializer

    def initialize(rows)
      @rows = rows
    end

    def scope
      @rows
    end

    def parse_object(results_row)
      self.class::ATTRIBUTES.map do |key, _value|
        presenter = FinanceReportPresenter.new(results_row)
        if presenter.respond_to?(key)
          presenter.public_send(key)
        else
          presenter[key]
        end
      end
    end

  end
end
