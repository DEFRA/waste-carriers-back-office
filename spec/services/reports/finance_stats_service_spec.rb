# frozen_string_literal: true

require "rails_helper"

RSpec.describe Reports::FinanceStatsService do
  describe ".run" do

    # Note that the test payments and orders are unrelated at the transaction level.
    # This is acceptable for unit test purposes as the service queries payments and orders/charges independently
    # and aggregates the results above the transaction level.
    include_context "with finance stats payment data"
    include_context "with finance stats order data"

    let(:payment_types) do
      %w[cash reversal postalorder refund govpay worldpay worldpaymissed cheque banktransfer writeoffsmall writeofflarge]
    end

    let(:charge_types) do
      %w[chargeadjust copycards newreg renew edit irimport]
    end

    # dates shorthand
    def period_yyyymm(date)
      date.strftime("%Y%m")
    end

    def period_yyyymmdd(date)
      date.strftime("%Y%m%d")
    end

    def result_for_yyyymm(date)
      subject.select { |result| result[:period] == period_yyyymm(date) }.first
    end

    def result_for_yyyymmdd(date)
      subject.select { |result| result[:period] == period_yyyymmdd(date) }.first
    end

    def result_for_month(month_index)
      result_for_yyyymm(month_index.months.ago)
    end

    def test_payments_tally_month(month_index)
      test_payment_tallies[month_index.months.ago.strftime("%Y-%m")]
    end

    def test_payments_tally_day(date)
      test_payment_tallies[date.strftime("%Y-%m-%d")]
    end

    def test_payments_total_month(month_index)
      test_payments_tally_month(month_index)[:totals][:amount]
    end

    def test_payments_total_day(date)
      test_payments_tally_day(date)[:totals][:amount]
    end

    def test_charges_tally_month(month_index)
      test_charge_tallies[month_index.months.ago.strftime("%Y-%m")]
    end

    def test_charges_tally_day(date)
      test_charge_tallies[date.strftime("%Y-%m-%d")]
    end

    def test_charges_total_month(month_index)
      test_charges_tally_month(month_index)[:totals][:amount]
    end

    def test_charges_total_day(date)
      test_charges_tally_day(date)[:totals][:amount]
    end

    context "with monthly granularity" do
      subject { described_class.new(:mmyyyy).run }

      context "with results structure" do

        it "returns the correct total number of entries" do
          # The finance_details factory creates additional orders for the current date when creating the payments.
          # Expect one top-level structure per month (with orders) in the order data, plus one for the current month.
          expect(subject.length).to eq 7
        end

        it "returns the correct top-level keys per row" do
          subject.each do |row|
            expect(row.keys).to match_array(%w[period year month balance renewals_due renewal_percent payments charges])
          end
        end
      end

      context "with results content" do

        it "returns the correct date values" do
          5.downto(3).each do |month_index|
            row_date = month_index.months.ago
            result = result_for_yyyymm(row_date)
            expect(result[:year]).to eq row_date.year
            expect(result[:month]).to eq row_date.month
            expect(result[:period]).to eq period_yyyymm(row_date)
          end
        end

        context "with renewals due and actual" do
          it "returns the correct expected renewal counts based on actual registrations 36 months previously" do
            5.downto(3).each do |month_index|
              # month indices are higher in the past because we use 'month_index.months.ago'
              registration_month_index = month_index + 36
              new_regs_36_months_ago = test_charges_tally_month(registration_month_index)["NEW"][:count]
              renewals_36_months_ago = test_charges_tally_month(registration_month_index)["RENEW"][:count]

              expect(result_for_month(month_index)[:renewals_due]).to eq new_regs_36_months_ago + renewals_36_months_ago
            end
          end

          it "returns the correct actual renewal percentage" do
            5.downto(3).each do |month_index|
              row = result_for_month(month_index)
              expect(row[:renewal_percent]).to eq row[:charges][:renew][:count].to_f / row[:renewals_due]
            end
          end
        end

        context "with payments" do

          it "returns entries for all payment types" do
            5.downto(3).each do |month_index|
              expect(result_for_month(month_index)[:payments].keys).to match_array(%w[count balance] + payment_types)
            end
          end

          it "returns the correct total payment count" do
            5.downto(3).each do |month_index|
              expect(result_for_month(month_index)[:payments][:count]).to eq test_payments_tally_month(month_index)[:totals][:count]
            end
          end

          it "returns the correct total payment amount" do
            5.downto(3).each do |month_index|
              expect(result_for_month(month_index)[:payments][:balance]).to eq test_payments_total_month(month_index)
            end
          end

          it "returns the correct aggregate counts for each payment type" do
            5.downto(3).each do |month_index|
              payment_types.each do |type|
                test_payments_count = test_payments_tally_month(month_index).dig(report_payment_type_map[type.to_s], :count) || 0
                expect(result_for_month(month_index)[:payments][type][:count]).to eq test_payments_count
              end
            end
          end

          it "returns the correct aggregate amounts for each payment type" do
            5.downto(3).each do |month_index|
              payment_types.each do |type|
                test_payments_amount = test_payments_tally_month(month_index).dig(report_payment_type_map[type.to_s], :amount) || 0
                expect(result_for_month(month_index)[:payments][type][:total]).to eq test_payments_amount
              end
            end
          end
        end

        context "with charges" do

          it "returns entries for all charge types" do
            5.downto(3).each do |month_index|
              expect(result_for_month(month_index)[:charges].keys).to match_array(%w[count balance] + charge_types)
            end
          end

          it "returns the correct total charge count" do
            5.downto(3).each do |month_index|
              expect(result_for_month(month_index)[:charges][:count]).to eq test_charges_tally_month(month_index)[:totals][:count]
            end
          end

          it "returns the correct total charge amount" do
            5.downto(3).each do |month_index|
              expect(result_for_month(month_index)[:charges][:balance]).to eq test_charges_total_month(month_index)
            end
          end

          it "returns the correct aggregate counts for each charge type" do
            5.downto(3).each do |month_index|
              charge_types.each do |type|
                test_charges_count = test_charges_tally_month(month_index).dig(report_charge_type_map[type.to_s], :count) || 0
                expect(result_for_month(month_index)[:charges][type][:count]).to eq test_charges_count
              end
            end
          end

          it "returns the correct aggregate amounts for each charge type" do
            5.downto(3).each do |month_index|
              charge_types.each do |type|
                test_charges_amount = test_charges_tally_month(month_index).dig(report_charge_type_map[type.to_s], :amount) || 0
                expect(result_for_month(month_index)[:charges][type][:total]).to eq test_charges_amount
              end
            end
          end
        end

        context "with balance" do
          it "returns the expected balance for each row" do
            5.downto(3).each do |month_index|
              expect(result_for_month(month_index)[:balance]).to eq test_charges_total_month(month_index) - test_payments_total_month(month_index)
            end
          end
        end
      end
    end

    # For unit test simplicity, all payments and orders for a month are created on the same day.
    context "with daily granularity" do
      subject { described_class.new(:ddmmyyyy).run }

      context "with results structure" do

        it "returns the correct total number of entries" do
          payment_dates = payment_data.map { |dt| dt[:date].strftime("%Y-%m-%d") }
          order_dates = order_data.map { |dt| dt[:date].strftime("%Y-%m-%d") }
          all_dates = (payment_dates + order_dates).uniq

          # The finance_details factory creates additional orders for the current date when creating the payments.
          # Expect one top-level structure per date in the test data, plus one for the current date.
          expect(subject.length).to eq all_dates.length + 1
        end

        it "returns the correct top-level keys per row" do
          subject.each do |row|
            expect(row.keys).to match_array(%w[period year month day balance payments charges])
          end
        end
      end

      context "with results content" do

        it "returns the correct date values" do
          5.downto(3).each do |month_index|
            row_date = month_index.months.ago
            result = result_for_yyyymmdd(row_date)
            expect(result[:year]).to eq row_date.year
            expect(result[:month]).to eq row_date.month
            expect(result[:day]).to eq row_date.day
            expect(result[:period]).to eq period_yyyymmdd(row_date)
          end
        end

        context "with payments" do

          it "returns entries for all payment types" do
            [5.months.ago, 5.months.ago + 1.day, 4.months.ago - 1.day, 4.months.ago, 3.months.ago].each do |date|
              expect(result_for_yyyymmdd(date)[:payments].keys).to match_array(%w[count balance] + payment_types)
            end
          end

          it "returns the correct total payment count" do
            [5.months.ago, 5.months.ago + 1.day, 4.months.ago - 1.day, 4.months.ago, 3.months.ago].each do |date|
              expect(result_for_yyyymmdd(date)[:payments][:count]).to eq test_payments_tally_day(date)[:totals][:count]
            end
          end

          it "returns the correct total payment amount" do
            [5.months.ago, 5.months.ago + 1.day, 4.months.ago - 1.day, 4.months.ago, 3.months.ago].each do |date|
              expect(result_for_yyyymmdd(date)[:payments][:balance]).to eq test_payments_total_day(date)
            end
          end

          it "returns the correct aggregate counts for each payment type" do
            [5.months.ago, 5.months.ago + 1.day, 4.months.ago - 1.day, 4.months.ago, 3.months.ago].each do |date|
              payment_types.each do |type|
                test_payments_count = test_payments_tally_day(date).dig(report_payment_type_map[type.to_s], :count) || 0
                expect(result_for_yyyymmdd(date)[:payments][type][:count]).to eq test_payments_count
              end
            end
          end

          it "returns the correct aggregate amounts for each payment type" do
            [5.months.ago, 5.months.ago + 1.day, 4.months.ago - 1.day, 4.months.ago, 3.months.ago].each do |date|
              payment_types.each do |type|
                test_payments_amount = test_payments_tally_day(date).dig(report_payment_type_map[type.to_s], :amount) || 0
                expect(result_for_yyyymmdd(date)[:payments][type][:total]).to eq test_payments_amount
              end
            end
          end
        end

        context "with charges" do

          it "returns entries for all charge types" do
            [5.months.ago, 5.months.ago + 1.day, 4.months.ago - 1.day, 4.months.ago, 3.months.ago].each do |date|
              expect(result_for_yyyymmdd(date)[:charges].keys).to match_array(%w[count balance] + charge_types)
            end
          end

          it "returns the correct total charge count" do
            [5.months.ago, 5.months.ago + 1.day, 4.months.ago - 1.day, 4.months.ago, 3.months.ago].each do |date|
              expect(result_for_yyyymmdd(date)[:charges][:count]).to eq test_charges_tally_day(date)[:totals][:count]
            end
          end

          it "returns the correct total charge amount" do
            [5.months.ago, 5.months.ago + 1.day, 4.months.ago - 1.day, 4.months.ago, 3.months.ago].each do |date|
              expect(result_for_yyyymmdd(date)[:charges][:balance]).to eq test_charges_total_day(date)
            end
          end

          it "returns the correct aggregate counts for each charge type" do
            [5.months.ago, 5.months.ago + 1.day, 4.months.ago - 1.day, 4.months.ago, 3.months.ago].each do |date|
              charge_types.each do |type|
                test_charges_count = test_charges_tally_day(date).dig(report_charge_type_map[type.to_s], :count) || 0
                expect(result_for_yyyymmdd(date)[:charges][type][:count]).to eq test_charges_count
              end
            end
          end

          it "returns the correct aggregate amounts for each charge type" do
            [5.months.ago, 5.months.ago + 1.day, 4.months.ago - 1.day, 4.months.ago, 3.months.ago].each do |date|
              charge_types.each do |type|
                test_charges_amount = test_charges_tally_day(date).dig(report_charge_type_map[type.to_s], :amount) || 0
                expect(result_for_yyyymmdd(date)[:charges][type][:total]).to eq test_charges_amount
              end
            end
          end
        end

        context "with balance" do

          it "returns the expected balance for each row" do
            [5.months.ago, 5.months.ago + 1.day, 4.months.ago - 1.day, 4.months.ago, 3.months.ago].each do |date|
              expect(result_for_yyyymmdd(date)[:balance]).to eq test_charges_total_day(date) - test_payments_total_day(date)
            end
          end
        end
      end
    end
  end
end
