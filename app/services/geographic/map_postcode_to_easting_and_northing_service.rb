# frozen_string_literal: true

module Geographic
  class MapPostcodeToEastingAndNorthingService < WasteCarriersEngine::BaseService
    def run(postcode:)
      @result = { easting: nil, northing: nil }

      easting_and_northing_from_postcode(postcode)

      @result
    end

    private

    def easting_and_northing_from_postcode(postcode)
      return if postcode.blank?

      response = WasteCarriersEngine::AddressLookupService.run(postcode)

      if response.successful?
        apply_result_coordinates(response.results.first)
      elsif response.error.is_a?(DefraRuby::Address::NoMatchError)
        no_match_from_postcode_lookup(postcode)
      else
        error_from_postcode_lookup(postcode, response.error)
      end
    end

    def apply_result_coordinates(result)
      @result[:easting] = result["easting"].to_f
      @result[:northing] = result["northing"].to_f
    end

    def handle_error(error, message, metadata)
      Airbrake.notify(error, metadata) if defined?(Airbrake)
      Rails.logger.error(message)
    end

    def no_match_from_postcode_lookup(postcode)
      default_do_not_fetch_again_coordinates

      message = "Postcode to easting and northing returned no results"
      handle_error(StandardError.new(message), message, postcode: postcode)
    end

    def error_from_postcode_lookup(postcode, error)
      default_do_not_fetch_again_coordinates

      message = "Postcode to easting and northing errored: #{error.message}"
      handle_error(StandardError.new(message), message, postcode: postcode)
    end

    def default_do_not_fetch_again_coordinates
      @result[:easting] = 0.00
      @result[:northing] = 0.00
    end
  end
end
