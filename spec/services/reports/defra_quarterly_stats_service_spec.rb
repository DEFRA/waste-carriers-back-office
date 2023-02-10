# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe DefraQuarterlyStatsService do

    # Minimal spec to pass coverage checks in CI for the initial minimalist version of this service
    describe ".run" do

      context "when the service is invoked" do
        it "generates a report" do
          expect { described_class.run }.not_to raise_error
        end
      end
    end

    describe "#quarter_start_month" do
      subject(:service) { described_class.new }

      shared_examples "quarter start" do |date, expected_month|
        it "returns #{expected_month}" do
          expect(service.send(:quarter_start_month, date)).to eq expected_month
        end

        it "does not return #{expected_month} for the previous day" do
          expect(service.send(:quarter_start_month, date - 1.day)).not_to eq expected_month
        end
      end

      shared_examples "quarter end" do |date, expected_month|
        it "returns #{expected_month}" do
          expect(service.send(:quarter_start_month, date)).to eq expected_month
        end

        it "does not return #{expected_month} for the next day" do
          expect(service.send(:quarter_start_month, date + 1.day)).not_to eq expected_month
        end
      end

      context "when q1" do
        it_behaves_like "quarter start", Date.new(2023, 4, 1), 4
        it_behaves_like "quarter end", Date.new(2023, 6, 30), 4
      end

      context "when q2" do
        it_behaves_like "quarter start", Date.new(2023, 7, 1), 7
        it_behaves_like "quarter end", Date.new(2023, 9, 30), 7
      end

      context "when q3" do
        it_behaves_like "quarter start", Date.new(2023, 10, 1), 10
        it_behaves_like "quarter end", Date.new(2023, 12, 31), 10
      end

      context "when q4" do
        it_behaves_like "quarter start", Date.new(2023, 1, 1), 1
        it_behaves_like "quarter end", Date.new(2023, 3, 31), 1
      end
    end

    describe "#quarter_dates" do
      subject(:service) { described_class.new }

      context "when in q1 2021/2022" do
        around do |example|
          Timecop.freeze(Date.new(2021, 4, 10)) do
            example.run
          end
        end

        context "with 0 quarters ago" do
          it "returns start and end dates for q1 2021/2022" do
            expect(service.send(:quarter_dates, 0)).to eq [Date.new(2021, 4, 1), Date.new(2021, 6, 30)]
          end
        end

        context "with 1 quarter ago" do
          it "returns start and end dates for q4 2020/2021" do
            expect(service.send(:quarter_dates, 1)).to eq [Date.new(2021, 1, 1), Date.new(2021, 3, 31)]
          end
        end

        context "with 2 quarters ago" do
          it "returns start and end dates for q3 2020/2021" do
            expect(service.send(:quarter_dates, 2)).to eq [Date.new(2020, 10, 1), Date.new(2020, 12, 31)]
          end
        end

        context "with 3 quarters ago" do
          it "returns start and end dates for q2 2020/2021" do
            expect(service.send(:quarter_dates, 3)).to eq [Date.new(2020, 7, 1), Date.new(2020, 9, 30)]
          end
        end

        context "with 4 quarters ago" do
          it "returns start and end dates for q1 2020/2021" do
            expect(service.send(:quarter_dates, 4)).to eq [Date.new(2020, 4, 1), Date.new(2020, 6, 30)]
          end
        end
      end
    end
  end
end
