# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe WasteCarriersEngine::JourneyLinksHelper, type: :helper do
    describe "renewal_finished_link" do
      it "returns the correct value" do
        reg_identifier = build(:renewing_registration).reg_identifier
        expected_path = "/bo/renewing-registrations/#{reg_identifier}"

        expect(helper.renewal_finished_link(reg_identifier: reg_identifier)).to eq(expected_path)
      end
    end
  end
end
