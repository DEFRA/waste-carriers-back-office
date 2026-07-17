# frozen_string_literal: true

module Geographic
  # Determines which EA area contains an easting and northing, using the
  # engine's geospatial lookup. Returns nil if the lookup fails.
  class MapEastingAndNorthingToEaAreaService < WasteCarriersEngine::BaseService
    def run(easting:, northing:)
      WasteCarriersEngine::DetermineEaAreaService.run(easting: easting, northing: northing)
    rescue StandardError => e
      handle_error(e, easting, northing)
      nil
    end

    private

    def handle_error(error, easting, northing)
      Airbrake.notify(error, easting: easting, northing: northing)
      Rails.logger.error "Area lookup failed:\n #{error}"
    end
  end
end
