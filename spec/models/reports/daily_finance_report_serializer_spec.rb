# frozen_string_literal: true

require "rails_helper"

module Reports
  RSpec.describe DailyFinanceReportSerializer do
    describe "#to_csv" do

      let(:finance_stats) { FinanceStatsService.new(:ddmmyyyy).run }
      let!(:registration) { create(:registration) }
      let(:payment_date) { registration.finance_details.payments.first.date_entered }
      let(:registration_report_period_mmyyyy) { format("%<year>04i%<month>02i", year: payment_date.year, month: payment_date.month) }
      let(:registration_report_period_ddmmyyyy) { format("%<year>04i%<month>02i%<day>02i", year: payment_date.year, month: payment_date.month, day: payment_date.day) }

      subject { described_class.new(finance_stats).to_csv }

      it "includes all expected columns only" do
        expect(subject).to include("period,year,month,day,balance,pay_cnt,pay_bal,pay_cash_cnt,pay_cash_tot,pay_reversal_cnt,pay_reversal_tot,pay_postalorder_cnt,pay_postalorder_tot,pay_refund_cnt,pay_refund_tot,pay_worldpay_cnt,pay_worldpay_tot,pay_worldpaymissed_cnt,pay_worldpaymissed_tot,pay_cheque_cnt,pay_cheque_tot,pay_banktransfer_cnt,pay_banktransfer_tot,pay_writeoffsmall_cnt,pay_writeoffsmall_tot,pay_writeofflarge_cnt,pay_writeofflarge_tot,chg_cnt,chg_bal,chg_chargeadjust_cnt,chg_chargeadjust_tot,chg_copycards_cnt,chg_copycards_tot,chg_new_cnt,chg_new_tot,chg_renew_cnt,chg_renew_tot,chg_edit_cnt,chg_edit_tot,chg_irimport_cnt,chg_irimport_tot")
      end

      it "includes registration payment amounts in pounds" do
        expect(subject).to include(format("%<pence>.2f", pence: (registration.finance_details.payments.first.amount / 100.0)))
      end

      it "includes registration order amounts in pounds" do
        expect(subject).to include(format("%<pence>.2f", pence: (registration.finance_details.orders.first.totalAmount / 100.0)))
      end

      it "includes the correct reporting period format" do
        expect(subject).not_to include "#{registration_report_period_mmyyyy},"
        expect(subject).to include registration_report_period_ddmmyyyy
      end
    end
  end
end
