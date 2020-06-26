# frozen_string_literal: true

module Api
  class LoadSeededDataService < ::WasteCarriersEngine::BaseService
    def run(**seed)
      @seed = seed

      seed_registration
    end

    private

    def seed_registration
      @seed["reg_identifier"] = reg_identifier
      @seed["expires_on"] = Rails.configuration.expires_after.years.from_now unless @seed["expires_on"]

      WasteCarriersEngine::Registration.find_or_create_by(@seed.except("_id"))
    end

    def reg_identifier
      @_reg_identifier ||= generate_reg_identifier
    end

    def generate_reg_identifier
      tier_identifier = @seed["tier"].downcase == "lower" ? "L" : "U"
      unique_identifier = ::WasteCarriersEngine::GenerateRegIdentifierService.run.to_s

      "CBD#{tier_identifier}#{unique_identifier}"
    end
  end
end
