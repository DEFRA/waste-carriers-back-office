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

    describe "#scope" do
      context "when a renewal is pending a conviction check" do
        let(:renewing_registration) do
          create(:renewing_registration, :requires_conviction_check,
                 finance_details: build(:finance_details, balance: balance))
        end
        let(:balance) { 0 }
        let(:original_registration) { renewing_registration.registration }

        before { renewing_registration }

        context "when the original registration is eligible for inclusion in the EPR" do
          it "includes the original registration" do
            expect(subject.send(:scope)).to include(original_registration)
          end

          it "does not include the renewing registration" do
            expect(subject.send(:scope)).not_to include(renewing_registration)
          end
        end

        context "when the original registration is not eligible for inclusion in the EPR" do
          before do
            original_registration.expires_on = Date.yesterday
            original_registration.save!
          end

          it "does not include the original registration" do
            expect(subject.send(:scope)).not_to include(original_registration)
          end

          context "with no unpaid balance" do
            let(:balance) { 0 }

            it "includes the renewing registration" do
              expect(subject.send(:scope)).to include(renewing_registration)
            end
          end

          context "with an unpaid balance" do
            let(:balance) { 1 }

            it "does not include the renewing registration" do
              expect(subject.send(:scope)).not_to include(renewing_registration)
            end
          end

          context "when the renewal has been revoked" do
            before do
              renewing_registration.metaData.status = "REVOKED"
              renewing_registration.save!
            end

            it "does not include the renewing registration" do
              expect(subject.send(:scope)).not_to include(renewing_registration)
            end
          end
        end
      end
    end
  end
end
