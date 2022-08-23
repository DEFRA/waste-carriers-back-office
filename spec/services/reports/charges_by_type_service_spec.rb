# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reports::ChargesByTypeService do
  describe ".run" do

    include_context "Finance stats order data"

    context "with invalid granularity" do
      subject { described_class.new(:nope).run }

      it "raises an exception" do
        expect { subject }.to raise_error(StandardError)
      end
    end

    context "with monthly granularity" do
      subject { described_class.new(:mmyyyy).run }

      it "returns the correct count for each charge type for each month" do
        [5.months.ago, 4.months.ago, 3.months.ago].each do |date|
          date_key = date.strftime("%Y-%m-%d")
          report_charge_type_map.each do |report_type, db_type|
            expected_count = test_charge_tallies.dig(date_key, db_type, :count) || 0
            report_count = subject.select { |r| r[:month] == date.month }
                                  .select { |charge| charge[:type] == report_type }
                                  .sum { |m| m[:count] }

            expect(report_count).to eq expected_count
          end
        end
      end

      it "returns the correct total payment amounts for each payment type for each month" do
        [5.months.ago, 4.months.ago, 3.months.ago].each do |date|
          date_key = date.strftime("%Y-%m-%d")
          report_charge_type_map.each do |report_type, db_type|
            expected_amount = test_charge_tallies.dig(date_key, db_type, :amount) || 0
            report_amount = subject.select { |r| r[:month] == date.month }
                                   .select { |charge| charge[:type] == report_type }
                                   .sum { |m| m[:total] }

            expect(report_amount).to eq expected_amount
          end
        end
      end
    end

    context "with daily granularity" do
      subject { described_class.new(:ddmmyyyy).run }

      it "returns the correct count for each charge type for each date" do
        [5.months.ago, 4.months.ago, 3.months.ago].each do |date|
          date_key = date.strftime("%Y-%m-%d")
          report_charge_type_map.each do |report_type, db_type|
            expected_count = test_charge_tallies.dig(date_key, db_type, :count) || 0
            report_count = subject.select { |r| r[:month] == date.month && r[:day] == date.day }
                                  .select { |charge| charge[:type] == report_type }
                                  .sum { |m| m[:count] }

            expect(report_count).to eq expected_count
          end
        end
      end

      it "returns the correct total payment amounts for each payment type for each date" do
        [5.months.ago, 4.months.ago, 3.months.ago].each do |date|
          date_key = date.strftime("%Y-%m-%d")
          report_charge_type_map.each do |report_type, db_type|
            expected_amount = test_charge_tallies.dig(date_key, db_type, :amount) || 0
            report_amount = subject.select { |r| r[:month] == date.month && r[:day] == date.day }
                                   .select { |charge| charge[:type] == report_type }
                                   .sum { |m| m[:total] }

            expect(report_amount).to eq expected_amount
          end
        end
      end
    end
  end
end
