# frozen_string_literal: true

module Address
  class UpdateEastingNorthingService < WasteCarriersEngine::BaseService
    attr_reader :address, :registration

    delegate :postcode, to: :address

    def run(reg_identifier:)
      @registration = WasteCarriersEngine::Registration.find_by(reg_identifier:)
      @address = @registration.registered_address

      return if address.easting.present? && address.northing.present?

      easting, northing = Geographic::MapPostcodeToEastingAndNorthingService.run(postcode: postcode).values
      address.update(easting:, northing:)
    end
  end
end
