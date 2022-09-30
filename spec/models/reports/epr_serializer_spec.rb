# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe EprSerializer do
    describe "#to_csv" do
      it "returns a csv version of the given data based on attributes" do
        allow(Rails.configuration).to receive(:grace_window).and_return(3)

        active = create(:registration, :active, expires_on: 3.days.from_now)
        expired = create(:registration, :expired, expires_on: 2.days.ago)

        result = subject.to_csv

        expect(result).to include("\"Registration number\",\"Organisation name\",\"UPRN\",\"Building\",\"Address line 1\",\"Address line 2\",\"Address line 3\",\"Address line 4\",\"Town\",\"Postcode\",\"Country\",\"Easting\",\"Northing\",\"Applicant type\",\"Registration tier\",\"Registration type\",\"Registration date\",\"Expiry date\",\"Company number\"")
        expect(result).to include(active.reg_identifier)
        expect(result).not_to include(expired.reg_identifier)
      end
    end
  end
end
