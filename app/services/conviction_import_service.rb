# frozen_string_literal: true

require "csv"

class InvalidCSVError < StandardError; end
class InvalidConvictionDataError < StandardError; end

class ConvictionImportService < ::WasteCarriersEngine::BaseService
  def run(csv)
    convictions_data = parse_data(csv)

    convictions_data.each do |line|
      add_conviction_record(line)
    end
  end

  private

  def parse_data(csv)
    CSV.parse(csv,
              converters: :date,
              headers: true,
              liberal_parsing: true,
              skip_blanks: true)
  rescue StandardError
    raise InvalidCSVError
  end

  def add_conviction_record(conviction)
    validate_conviction_data(conviction)

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

  def validate_conviction_data(data)
    valid_headers?(data) && name_is_present?(data)
  end

  def valid_headers?(data)
    return true if data.headers == ["Offender", "Birth Date", "Company No.", "System Flag", "Inc Number"]

    raise InvalidConvictionDataError, "Invalid headers"
  end

  def name_is_present?(data)
    return true if data["Offender"].present?

    raise InvalidConvictionDataError, "Offender name missing"
  end
end
