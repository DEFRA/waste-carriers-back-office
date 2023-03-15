# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe DeregistrationEmailExportService do

    # Tests for the structure and content of the report are in the serializer_spec.
    describe ".run" do

      let(:eligible_registration) do
        create(:registration, :active, metaData: build(:metaData, dateRegistered: 15.months.ago, tier: "LOWER"))
      end
      let(:batch_size) { 100 }

      before do
        allow(Airbrake).to receive(:notify)
        allow(Rails.logger).to receive(:error)
      end

      context "when the report is successfully generated and uploaded to S3" do
        before do
          stub_request(
            :put,
            %r{https://.*\.amazonaws\.com/EMAIL_EXPORTS/lower_tier_dereg_emails_.*\.csv}
          )
        end

        it "generates a CSV file and uploads it to AWS S3" do
          described_class.run(batch_size)

          expect(Airbrake).not_to have_received(:notify)
          expect(Rails.logger).not_to have_received(:error)
        end

        it "creates an EmailExportLog" do
          expect { described_class.run(batch_size) }.to change(EmailExportLog, :count).by(1)
        end
      end

      context "when an error happens" do
        before do
          stub_request(
            :put,
            %r{https://.*\.amazonaws\.com/EMAIL_EXPORTS/lower_tier_dereg_emails_.*\.csv}
          ).to_return(status: 403)
        end

        it "raises an error" do
          described_class.run(batch_size)

          expect(Airbrake).to have_received(:notify)
          expect(Rails.logger).to have_received(:error)
        end
      end
    end
  end
end
