# frozen_string_literal: true

require "csv"

class InvalidCSVError < StandardError; end
class InvalidConvictionDataError < StandardError; end

class ConvictionImportService < WasteCarriersEngine::BaseService
  def run(csv)
    @old_convictions = WasteCarriersEngine::ConvictionsCheck::Entity.all
    @new_convictions = []

    convert_data_to_convictions(csv)
    update_convictions_in_database
  end

  private

  def convert_data_to_convictions(csv)
    convictions_data = parse_data(csv)

    validate_headers(convictions_data)

    convictions_data.each do |line|
      make_new_conviction_object(line)
    end
  end

  def update_convictions_in_database
    @old_convictions.each(&:destroy!)
    @new_convictions.each(&:save!)
  end

  def parse_data(csv)
    CSV.parse(csv,
              converters: :date,
              headers: true,
              liberal_parsing: true,
              skip_blanks: true)
  rescue StandardError
    raise InvalidCSVError
  end

  def make_new_conviction_object(conviction)
    validate_row(conviction)

    attributes = prepare_attributes(conviction)
    @new_convictions << WasteCarriersEngine::ConvictionsCheck::Entity.new(attributes)
  end

  def prepare_attributes(conviction)
    # Strip whitespace from each one if possible, then call 'presence'
    # to return nil instead of a blank string
    {
      name: conviction["Offender"]&.strip.presence,
      date_of_birth: conviction["Birth Date"],
      company_number: conviction["Company No."]&.strip.presence,
      system_flag: conviction["System Flag"]&.strip.presence,
      incident_number: conviction["Inc Number"]&.strip.presence
    }
  end

  def validate_headers(data)
    return if data.headers == ["Offender", "Birth Date", "Company No.", "System Flag", "Inc Number"]

    raise InvalidConvictionDataError, "Invalid headers"
  end

  def validate_row(row)
    validate_name(row["Offender"]) && validate_date_of_birth(row["Birth Date"])
  end

  def validate_name(name)
    return true if name.present?

    raise InvalidConvictionDataError, "Offender name missing"
  end

  def validate_date_of_birth(date_of_birth)
    return true if date_of_birth.blank?

    Date.parse(date_of_birth)
  rescue ArgumentError
    raise InvalidConvictionDataError, "Invalid date of birth"
  end
end
