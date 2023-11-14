# frozen_string_literal: true

require "rails_helper"

RSpec.describe RemoveDeletableRegistrationsService do

  # Use meaningful reg_identifier strings to facilitate test conditions and debugging
  let(:ceased_11_years_ago) { create(:registration, :ceased, reg_identifier: "ceased_11_years_ago") }
  let(:ceased_8_years_ago) { create(:registration, :ceased, reg_identifier: "ceased_8_years_ago") }
  let(:ceased) { create(:registration, :ceased, reg_identifier: "ceased") }

  let(:expired_11_years_ago) { create(:registration, :expired, reg_identifier: "expired_11_years_ago") }
  let(:expired_8_years_ago) { create(:registration, :expired, reg_identifier: "expired_8_years_ago") }
  let(:expired) { create(:registration, :expired, reg_identifier: "expired") }

  let(:revoked_11_years_ago) { create(:registration, :revoked, reg_identifier: "revoked_11_years_ago") }
  let(:revoked_8_years_ago) { create(:registration, :revoked, reg_identifier: "revoked_8_years_ago") }
  let(:revoked) { create(:registration, :revoked, reg_identifier: "revoked") }

  let(:pending_conviction_check_11_years_ago) { create(:registration, :requires_conviction_check, reg_identifier: "pending_conviction_check_11_years_ago") }
  let(:pending_conviction_check_8_years_ago) { create(:registration, :requires_conviction_check, reg_identifier: "pending_conviction_check_8_years_ago") }

  let(:pending_payment_11_years_ago) { create(:registration, :pending_payment, reg_identifier: "pending_payment_11_years_ago") }
  let(:pending_payment_8_years_ago) { create(:registration, :pending_payment, reg_identifier: "pending_payment_8_years_ago") }

  describe ".run" do

    before do
      [
        ceased_11_years_ago,
        expired_11_years_ago,
        revoked_11_years_ago,
        pending_conviction_check_11_years_ago,
        pending_payment_11_years_ago
      ].each do |registration|
        registration.metaData.update(last_modified: 11.years.ago)
      end

      [
        ceased_8_years_ago,
        expired_8_years_ago,
        revoked_8_years_ago,
        pending_conviction_check_8_years_ago,
        pending_payment_8_years_ago
      ].each do |registration|
        registration.metaData.update(last_modified: 8.years.ago)
      end

      # instantiate these also
      ceased
      expired
      revoked
    end

    context "with the default data retention period" do

      it "deletes registrations last modified before the start of the retention period, excluding any pending conviction checks" do
        described_class.run

        expect(WasteCarriersEngine::Registration.pluck(:reg_identifier)).to contain_exactly(
          "pending_conviction_check_11_years_ago",
          "pending_conviction_check_8_years_ago",
          "ceased",
          "expired",
          "revoked"
        )
      end
    end

    context "with a data retention period of 10 years" do

      before { allow(Rails.configuration).to receive(:data_retention_years).and_return("10") }

      it "deletes registrations last modified before the start of the retention period, excluding any pending conviction checks" do
        described_class.run

        expect(WasteCarriersEngine::Registration.pluck(:reg_identifier)).to contain_exactly(
          "pending_conviction_check_11_years_ago",
          "ceased_8_years_ago",
          "expired_8_years_ago",
          "revoked_8_years_ago",
          "pending_conviction_check_8_years_ago",
          "pending_payment_8_years_ago",
          "ceased",
          "expired",
          "revoked"
        )
      end
    end
  end
end
