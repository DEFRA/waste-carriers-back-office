# frozen_string_literal: true

require "csv"

class ConvictionImportService < ::WasteCarriersEngine::BaseService
  def run(csv)
    convictions_data = parse_data(csv)

    convictions_data.each do |line|
      add_conviction_record(line)
    end
  end

  private

  def parse_data(csv)
    CSV.parse(csv, headers: true, liberal_parsing: true, skip_blanks: true)
  end

  def add_conviction_record(conviction)
    attributes = prepare_attributes(conviction)
    WasteCarriersEngine::ConvictionsCheck::Entity.new(attributes).save
  end

  def prepare_attributes(conviction)
    {
      name: conviction["Offender"],
      date_of_birth: conviction["Birth Date"],
      company_number: conviction["Company No."],
      system_flag: conviction["System Flag"],
      incident_number: conviction["Inc Number"]
    }
  end
end
