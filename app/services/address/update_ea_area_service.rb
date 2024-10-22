# frozen_string_literal: true

module Address
  class UpdateEaAreaService < WasteCarriersEngine::BaseService
    attr_reader :address, :registration, :easting, :northing

    delegate :postcode, :area, to: :address

    def run(registration_id:)
      @registration = WasteCarriersEngine::Registration.find(registration_id)
      @address = @registration.registered_address

      set_easting_and_northing
      assign_area
    end

    private

    def set_easting_and_northing
      return if address.easting.present? && address.northing.present?

      @easting, @northing = Geographic::MapPostcodeToEastingAndNorthingService.run(postcode: postcode).values
    end

    def assign_area
      return if area.present?

      if registration.overseas?
        address.update(area: "Outside England")
        return
      end

      address.update(area: Geographic::MapEastingAndNorthingToEaAreaService.run(easting:, northing:))
    end
  end
end
