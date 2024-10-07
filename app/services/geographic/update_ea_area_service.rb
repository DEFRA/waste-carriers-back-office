# frozen_string_literal: true

module Geographic
  class UpdateEaAreaService < WasteCarriersEngine::BaseService
    attr_reader :address, :registration, :easting, :northing

    delegate :postcode, :area, to: :address

    def run(registration_id:)
      @registration = WasteCarriersEngine::Registration.find(registration_id)
      @address = @registration.company_address

      set_easting_and_northing
      assign_area
    end

    private

    def set_easting_and_northing
      return if address.easting.present? && address.northing.present?

      @easting, @northing = DetermineEastingAndNorthingService.run(postcode: postcode).values
    end

    def assign_area
      return if area.present?

      if registration.overseas?
        address.update(area: "Outside England")
        return
      end

      address.update(area: DetermineEaAreaService.run(easting:, northing:))
    end
  end
end
