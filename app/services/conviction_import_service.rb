# frozen_string_literal: true

require "csv"

class ConvictionImportService < ::WasteCarriersEngine::BaseService
  def run(csv)
    CSV.parse(csv, liberal_parsing: true, skip_blanks: true)
  end
end
