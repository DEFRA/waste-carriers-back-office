# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe EprSerializer do
    describe "#to_csv" do
      let!(:active) { create(:registration, :active, expires_on: 3.days.from_now) }
      let!(:expired) { create(:registration, :expired, expires_on: 2.days.ago) }
      let!(:bad_registration) { create(:registration, :active, expires_on: 3.days.from_now) }
      let!(:good_registration) { create(:registration, :active, expires_on: 3.days.from_now) }

      let(:file_path) { Rails.root.join("tmp/epr_export.csv") }
      let(:export_content) { File.read(file_path) }

      before do
        allow(Airbrake).to receive(:notify)
        allow(Rails.configuration).to receive(:grace_window).and_return(3)

        # The serializer needs every registration to have a registered address:
        bad_registration.addresses.update(address_type: "POSTAL")

        described_class.new(path: file_path).to_csv
      end

      after { FileUtils.rm_f(file_path) }

      it "returns a csv object with the expected headers" do
        expect(export_content).to include("\"Registration number\",\"Organisation name\",\"UPRN\",\"Building\",\"Address line 1\",\"Address line 2\",\"Address line 3\",\"Address line 4\",\"Town\",\"Postcode\",\"Country\",\"Easting\",\"Northing\",\"Applicant type\",\"Registration tier\",\"Registration type\",\"Registration date\",\"Expiry date\",\"Company number\"")
      end

      it "includes the active registration" do
        expect(export_content).to include(active.reg_identifier)
      end

      it "does not include the expired registration" do
        expect(export_content).not_to include(expired.reg_identifier)
      end

      context "when a registration is missing required data" do
        it "continues processing after the bad registration" do
          aggregate_failures do
            expect(export_content).not_to include(bad_registration.reg_identifier)
            expect(export_content).to include(good_registration.reg_identifier)
          end
        end
      end
    end

    describe "#scope" do
      let(:renewing_registration) do
        create(:renewing_registration, :requires_conviction_check,
               finance_details: build(:finance_details, balance: balance))
      end
      let(:balance) { 0 }
      let(:original_registration) { renewing_registration.registration }

      context "when the original registration is eligible for inclusion in the EPR" do
        it "includes the original registration" do
          expect(subject.send(:scope)).to include(original_registration)
        end

        it "dos not include the renewing registration" do
          expect(subject.send(:scope)).not_to include(renewing_registration)
        end
      end

      context "when the registration expires later today" do
        before do
          original_registration.expires_on = 3.minutes.from_now
          original_registration.save!
        end

        # Decision: https://eaflood.atlassian.net/browse/RUBY-2249?focusedCommentId=470109
        it "does not include the registration" do
          expect(subject.send(:scope)).not_to include(original_registration)
        end
      end
    end
  end
end
