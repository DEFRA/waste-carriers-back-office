# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe EprRenewalSerializer do
    let(:file_path) { Rails.root.join("tmp/epr_export.csv") }

    describe "#to_csv" do
      let!(:active) { create(:registration, :active, expires_on: 3.days.from_now) }
      let!(:renewing_registration) do
        create(:renewing_registration, :requires_conviction_check, reg_identifier: active.reg_identifier,
                                                                   finance_details: build(:finance_details, balance: 0))
      end
      let(:export_content) { File.read(file_path) }

      before do
        allow(Rails.configuration).to receive(:grace_window).and_return(3)
        csv = described_class.new(path: file_path).to_csv
      ensure
        csv.close unless csv.nil? || csv.closed?
      end

      it "returns a csv object with the expected headers" do
        expect(export_content).to include("\"Registration number\",\"Organisation name\",\"UPRN\",\"Building\",\"Address line 1\",\"Address line 2\",\"Address line 3\",\"Address line 4\",\"Town\",\"Postcode\",\"Country\",\"Easting\",\"Northing\",\"Applicant type\",\"Registration tier\",\"Registration type\",\"Registration date\",\"Expiry date\",\"Company number\"")
      end

      it "does not include both the renewing registration and the original active registration" do
        expect(export_content).to include(renewing_registration.reg_identifier).once
      end
    end

    describe "#scope" do
      context "when a renewal is pending a conviction check" do
        let(:renewing_registration) do
          create(:renewing_registration, :requires_conviction_check,
                 finance_details: build(:finance_details, balance: balance))
        end
        let(:balance) { 0 }
        let(:original_registration) { renewing_registration.registration }

        subject(:serializer) { described_class.new(path: file_path) }

        before do
          original_registration.expires_on = Date.yesterday
          original_registration.save!
        end

        it "does not include the original registration" do
          expect(serializer.send(:scope)).not_to include(original_registration)
        end

        context "with no unpaid balance" do
          let(:balance) { 0 }

          it "includes the renewing registration" do
            expect(serializer.send(:scope)).to include(renewing_registration)
          end
        end

        context "with an unpaid balance" do
          let(:balance) { 1 }

          it "does not include the renewing registration" do
            expect(serializer.send(:scope)).not_to include(renewing_registration)
          end
        end

        context "when the renewal has been revoked" do
          before do
            renewing_registration.metaData.status = "REVOKED"
            renewing_registration.save!
          end

          it "does not include the renewing registration" do
            expect(serializer.send(:scope)).not_to include(renewing_registration)
          end
        end
      end
    end
  end
end
