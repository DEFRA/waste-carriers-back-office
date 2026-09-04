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
        apply_result_coordinates(postcode, response.results.first)
      elsif response.error.is_a?(DefraRuby::Address::NoMatchError)
        no_match_from_postcode_lookup(postcode)
      else
        error_from_postcode_lookup(postcode, response.error)
      end
    end

    # The address lookup returns coordinates as x and y
    def apply_result_coordinates(postcode, result)
      easting = result["x"]
      northing = result["y"]

      # Zero is never a valid coordinate, it is the grid origin out at sea
      if easting.to_f.zero? || northing.to_f.zero?
        return error_from_postcode_lookup(postcode, StandardError.new("no usable coordinates in the lookup result"))
      end

      @result[:easting] = easting.to_f
      @result[:northing] = northing.to_f
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
