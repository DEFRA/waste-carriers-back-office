# frozen_string_literal: true

module Address
  class UpdateEastingNorthingService < WasteCarriersEngine::BaseService
    attr_reader :address, :registration

    delegate :postcode, to: :address

    def run(registration_id:)
      @registration = WasteCarriersEngine::Registration.find(registration_id)
      @address = @registration.company_address

      return if address.easting.present? && address.northing.present?

      easting, northing = Geographic::MapPostcodeToEastingAndNorthingService.run(postcode: postcode).values
      address.update(easting:, northing:)
    end
  end
end
