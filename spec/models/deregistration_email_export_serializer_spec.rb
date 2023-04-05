# frozen_string_literal: true

require "rails_helper"

RSpec.describe DeregistrationEmailExportSerializer do

  subject(:serializer) { described_class.new(file_path, email_type, email_template_id, batch_size) }

  let!(:eligible_registration_1) do
    create(:registration,
           tier: "LOWER",
           metaData: build(:metaData,
                           :active,
                           dateRegistered: 15.months.ago))
  end

  let!(:eligible_registration_2) do
    create(:registration,
           tier: "LOWER",
           metaData: build(:metaData,
                           :active,
                           dateRegistered: 2.years.ago))
  end

  let!(:recent_registration) do
    create(:registration,
           tier: "LOWER",
           metaData: build(:metaData,
                           :active,
                           dateRegistered: 3.months.ago))
  end

  let!(:upper_tier_registration) do
    create(:registration,
           tier: "UPPER",
           metaData: build(:metaData,
                           :active,
                           dateRegistered: 15.months.ago))
  end

  let!(:revoked_registration) do
    create(:registration,
           tier: "LOWER",
           metaData: build(:metaData,
                           :revoked,
                           dateRegistered: 15.months.ago))
  end

  let!(:no_email_registration) do
    create(:registration,
           tier: "LOWER",
           contact_email: nil,
           metaData: build(:metaData,
                           :active,
                           dateRegistered: 15.months.ago))
  end

  let!(:empty_email_registration) do
    create(:registration,
           tier: "LOWER",
           contact_email: "",
           metaData: build(:metaData,
                           :active,
                           dateRegistered: 15.months.ago))
  end

  let!(:already_emailed_registration) do
    create(:registration,
           tier: "LOWER",
           metaData: build(:metaData,
                           :active,
                           dateRegistered: 15.months.ago),
           email_history: [{ description: "foo", template_id: email_template_id, time: Time.zone.now }])
  end

  let(:file_path) { Rails.root.join("tmp/card_orders_file.csv") }
  let(:email_type) { "Lower-tier deregistration pilot email" }
  let(:email_template_id) { "a-template-id" }
  let(:batch_size) { 10 }

  describe "#to_csv" do
    let(:export_content) { File.read(file_path) }

    context "when creating an export" do

      let(:cutoff_months) { 12 }

      before do
        allow(ENV).to receive(:fetch).with("DEREGISTRATION_EMAIL_CUTOFF_MONTHS", any_args).and_return(cutoff_months.to_s)
        serializer.to_csv
      end

      it "includes the expected headers" do
        expected_columns = %w[
          reg_identifier
          email_address
          company_name
          first_name
          last_name
          deregistration_link
        ].freeze

        expect(export_content).to include(expected_columns.map { |title| "\"#{title}\"" }.join(","))
      end

      it "includes the eligible registrations" do
        expect(export_content.scan(eligible_registration_1.reg_identifier).size).to eq 1
        expect(export_content.scan(eligible_registration_2.reg_identifier).size).to eq 1
      end

      it "includes the older eligible registration before the more recent one" do
        expect(export_content).to match(/#{eligible_registration_2.reg_identifier}.*\n*.*#{eligible_registration_1.reg_identifier}/)
      end

      it "does not include the already-emailed registration" do
        expect(export_content.scan(already_emailed_registration.reg_identifier).size).to eq 0
      end

      it "does not include the upper tier registration" do
        expect(export_content.scan(upper_tier_registration.reg_identifier).size).to eq 0
      end

      it "does not include the recent registration" do
        expect(export_content.scan(recent_registration.reg_identifier).size).to eq 0
      end

      it "does not include the revoked registration" do
        expect(export_content.scan(revoked_registration.reg_identifier).size).to eq 0
      end

      it "does not include a registration with no contact_email" do
        expect(export_content.scan(no_email_registration.reg_identifier).size).to eq 0
      end

      it "does not include a registration with an empty string as contact_email" do
        expect(export_content.scan(empty_email_registration.reg_identifier).size).to eq 0
      end

      context "when the cutoff months environment variable is set" do
        let(:cutoff_months) { 2 }

        it "includes the recent registration" do
          expect(export_content.scan(recent_registration.reg_identifier).size).to eq 1
        end
      end
    end

    context "when the number of eligible registrations exceeds the batch size" do
      before do
        create_list(:registration, 15,
                    :active,
                    tier: "LOWER",
                    metaData: build(:metaData, dateRegistered: 15.months.ago))
        serializer.to_csv
      end

      it "includes only the batch size number of rows (plus header)" do
        expect(export_content.scan("\n").length).to eq batch_size + 1
      end
    end

    context "when serializing the export" do
      it "updates the email history for an eligible registration" do
        expect { serializer.to_csv }.to change { eligible_registration_1.reload.email_history.length }.by(1)
      end

      it "does not modify the email history for an ineligible registration" do
        expect { serializer.to_csv }.not_to change { recent_registration.reload.email_history.length }
      end
    end
  end
end
