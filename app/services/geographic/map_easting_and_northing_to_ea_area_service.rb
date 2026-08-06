# frozen_string_literal: true

module Geographic
  # Determines which EA area contains an easting and northing, using the
  # engine's geospatial lookup. Returns nil if the lookup fails.
  class MapEastingAndNorthingToEaAreaService < WasteCarriersEngine::BaseService
    def run(easting:, northing:)
      # Without the boundaries loaded every point looks like it is outside
      # England, so return nothing rather than an area we cannot determine
      return nil unless WasteCarriersEngine::EaPublicFaceArea.exists?

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
