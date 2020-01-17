# frozen_string_literal: true

require "csv"

class ConvictionImportService < ::WasteCarriersEngine::BaseService
  def run(csv)
    convictions_data = parse_data(csv)

    convictions_data.each do |line|
      add_conviction_record(line)
    end

    convictions_data
  end

  private

  def parse_data(csv)
    CSV.parse(csv, liberal_parsing: true, skip_blanks: true)
  end

  def add_conviction_record(conviction)
    attributes = convert_array_to_attributes_hash(conviction)
    WasteCarriersEngine::ConvictionsCheck::Entity.new(attributes).save
  end

  def convert_array_to_attributes_hash(conviction)
    {
      name: conviction[0],
      date_of_birth: conviction[1],
      company_number: conviction[2],
      system_flag: conviction[3],
      incident_number: conviction[4]
    }
  end
end
