# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reports::FinanceStatsService do
  describe ".run" do

    # Note that the test payments and orders are unrelated at the transaction level.
    # This is acceptable for unit test purposes as the service queries payments and orders/charges independently
    # and aggregates the results above the transaction level.
    include_context "Finance stats payment data"
    include_context "Finance stats order data"

    let(:payment_types) do
      %i[cash reversal postalorder refund worldpay worldpaymissed cheque banktransfer writeoffsmall writeofflarge]
    end

    let(:charge_types) do
      %i[chargeadjust copycards newreg renew edit irimport]
    end

    # dates shorthand
    let(:test_data_dates) { [5.months.ago, 4.months.ago, 3.months.ago] }
    let(:date_keys) { test_data_dates.map { |d| d.strftime("%Y-%m-%d") } }
    let(:yyyy) { test_data_dates.map(&:year) }
    let(:mm) { test_data_dates.map(&:month) }
    let(:dd) { test_data_dates.map(&:day) }
    let(:yyyymm) { (0..2).map { |index| format("%<year>04i%<month>02i", year: yyyy[index], month: mm[index]).to_s } }
    let(:yyyymmdd) { (0..2).map { |index| format("%<year>04i%<month>02i%<day>02i", year: yyyy[index], month: mm[index], day: dd[index]).to_s } }

    let(:test_payments_totals) { (0..2).map { |index| test_payment_tallies[date_keys[index]].map { |_type, data| data[:amount] }.sum } }
    let(:test_charges_totals) { (0..2).map { |index| test_charge_tallies[date_keys[index]].map { |_type, data| data[:amount] }.sum } }

    context "with monthly granulariy" do
      subject { described_class.new(:mmyyyy).run }

      context "results structure" do

        it "returns the correct total number of entries" do
          # The finance_details factory creates additional orders for the current date when creating the payments.
          # Expect one top-level structure per month in the test data, plus one for the current month.
          expect(subject.to_a.length).to eq 4
        end

        it "returns the correct top-level keys per row" do
          subject.each do |row|
            expect(row.keys).to match_array(%i[period year month balance payments charges])
          end
        end
      end

      context "results content" do

        # Note that the rows are expected to be in month order and this is tested below using "(0..2).each do |month|"

        it "returns the correct date values" do
          (0..2).each do |month|
            expect(subject[month][:year]).to eq yyyy[month]
            expect(subject[month][:month]).to eq mm[month]
            expect(subject[month][:period]).to eq yyyymm[month]
          end
        end

        context "payments" do
          it "returns entries for all payment types" do
            (0..2).each do |month|
              expect(subject[month][:payments].keys).to match_array(%i[count balance] + payment_types)
            end
          end

          it "returns the correct total payment count" do
            (0..2).each do |month|
              expect(subject[month][:payments][:count]).to eq test_payment_tallies[date_keys[month]].map { |_type, data| data[:count] }.sum
            end
          end

          it "returns the correct total payment amount" do
            (0..2).each do |month|
              expect(subject[month][:payments][:balance]).to eq test_payments_totals[month]
            end
          end

          it "returns the correct aggregate counts for each payment type" do
            (0..2).each do |month|
              payment_types.each do |type|
                test_payments_count = test_payment_tallies.dig(date_keys[month], report_payment_type_map[type.to_s], :count) || 0
                expect(subject[month][:payments][type][:count]).to eq test_payments_count
              end
            end
          end

          it "returns the correct aggregate amounts for each payment type" do
            (0..2).each do |month|
              payment_types.each do |type|
                test_payments_amount = test_payment_tallies.dig(date_keys[month], report_payment_type_map[type.to_s], :amount) || 0
                expect(subject[month][:payments][type][:total]).to eq test_payments_amount
              end
            end
          end
        end

        context "charges" do
          it "returns entries for all charge types" do
            (0..2).each do |month|
              expect(subject[month][:charges].keys).to match_array(%i[count balance] + charge_types)
            end
          end

          it "returns the correct total charge count" do
            (0..2).each do |month|
              expect(subject[month][:charges][:count]).to eq test_charge_tallies[date_keys[month]].map { |_type, data| data[:count] }.sum
            end
          end

          it "returns the correct total charge amount" do
            (0..2).each do |month|
              expect(subject[month][:charges][:balance]).to eq test_charges_totals[month]
            end
          end

          it "returns the correct aggregate counts for each charge type" do
            (0..2).each do |month|
              charge_types.each do |type|
                test_charges_count = test_charge_tallies.dig(date_keys[month], report_charge_type_map[type.to_s], :count) || 0
                expect(subject[month][:charges][type][:count]).to eq test_charges_count
              end
            end
          end

          it "returns the correct aggregate amounts for each charge type" do
            (0..2).each do |month|
              charge_types.each do |type|
                test_charges_amount = test_charge_tallies.dig(date_keys[month], report_charge_type_map[type.to_s], :amount) || 0
                expect(subject[month][:charges][type][:total]).to eq test_charges_amount
              end
            end
          end
        end

        context "balance" do
          it "returns the expected balance for each row" do
            (0..2).each do |month|
              expect(subject[month][:balance]).to eq test_charges_totals[month] - test_payments_totals[month]
            end
          end
        end
      end
    end

    context "with daily granulariy" do
      subject { described_class.new(:ddmmyyyy).run }

      context "results structure" do

        it "returns the correct total number of entries" do
          # The finance_details factory creates additional orders for the current date when creating the payments.
          # Expect one top-level structure per date in the test data, plus one for the current date.
          expect(subject.to_a.length).to eq 4
        end

        it "returns the correct top-level keys per row" do
          subject.each do |row|
            expect(row.keys).to match_array(%i[period year month day balance payments charges])
          end
        end
      end

      context "results content" do

        # Note that the rows are expected to be in date order and this is tested below using "(0..2).each do |date|"

        it "returns the correct date values" do
          (0..2).each do |date|
            expect(subject[date][:year]).to eq yyyy[date]
            expect(subject[date][:month]).to eq mm[date]
            expect(subject[date][:day]).to eq dd[date]
            expect(subject[date][:period]).to eq yyyymmdd[date]
          end
        end

        context "payments" do
          it "returns entries for all payment types" do
            (0..2).each do |date|
              expect(subject[date][:payments].keys).to match_array(%i[count balance] + payment_types)
            end
          end

          it "returns the correct total payment count" do
            (0..2).each do |date|
              expect(subject[date][:payments][:count]).to eq test_payment_tallies[date_keys[date]].map { |_type, data| data[:count] }.sum
            end
          end

          it "returns the correct total payment amount" do
            (0..2).each do |date|
              expect(subject[date][:payments][:balance]).to eq test_payments_totals[date]
            end
          end

          it "returns the correct aggregate counts for each payment type" do
            (0..2).each do |date|
              payment_types.each do |type|
                test_payments_count = test_payment_tallies.dig(date_keys[date], report_payment_type_map[type.to_s], :count) || 0
                expect(subject[date][:payments][type][:count]).to eq test_payments_count
              end
            end
          end

          it "returns the correct aggregate amounts for each payment type" do
            (0..2).each do |date|
              payment_types.each do |type|
                test_payments_amount = test_payment_tallies.dig(date_keys[date], report_payment_type_map[type.to_s], :amount) || 0
                expect(subject[date][:payments][type][:total]).to eq test_payments_amount
              end
            end
          end
        end

        context "charges" do
          it "returns entries for all charge types" do
            (0..2).each do |date|
              expect(subject[date][:charges].keys).to match_array(%i[count balance] + charge_types)
            end
          end

          it "returns the correct total charge count" do
            (0..2).each do |date|
              expect(subject[date][:charges][:count]).to eq test_charge_tallies[date_keys[date]].map { |_type, data| data[:count] }.sum
            end
          end

          it "returns the correct total charge amount" do
            (0..2).each do |date|
              expect(subject[date][:charges][:balance]).to eq test_charges_totals[date]
            end
          end

          it "returns the correct aggregate counts for each charge type" do
            (0..2).each do |date|
              charge_types.each do |type|
                test_charges_count = test_charge_tallies.dig(date_keys[date], report_charge_type_map[type.to_s], :count) || 0
                expect(subject[date][:charges][type][:count]).to eq test_charges_count
              end
            end
          end

          it "returns the correct aggregate amounts for each charge type" do
            (0..2).each do |date|
              charge_types.each do |type|
                test_charges_amount = test_charge_tallies.dig(date_keys[date], report_charge_type_map[type.to_s], :amount) || 0
                expect(subject[date][:charges][type][:total]).to eq test_charges_amount
              end
            end
          end
        end

        context "balance" do
          it "returns the expected balance for each row" do
            (0..2).each do |date|
              expect(subject[date][:balance]).to eq test_charges_totals[date] - test_payments_totals[date]
            end
          end
        end
      end
    end
  end
end
