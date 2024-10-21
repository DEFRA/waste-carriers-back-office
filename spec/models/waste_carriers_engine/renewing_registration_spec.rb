# frozen_string_literal: true

require "rails_helper"

module WasteCarriersEngine
  RSpec.describe RenewingRegistration do

    describe "#future_expiry_date" do
      subject(:renewing_registration) { build(:renewing_registration) }

      it "adds three years to the original registration's expiry date" do
        expect(renewing_registration.future_expiry_date).to eq renewing_registration.expires_on + 3.years
      end
    end

    describe "scopes" do
      it_behaves_like "TransientRegistration named scopes"
    end
  end
end
