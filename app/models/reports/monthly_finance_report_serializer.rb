# frozen_string_literal: true

module Reports
  class MonthlyFinanceReportSerializer < BaseSerializer
    ATTRIBUTES = {
      period: "period",
      year: "year",
      month: "month",
      balance: "balance",
      renewals_due: "renewals_due",
      renewal_percent: "renewal_percent",
      pay_cnt: "pay_cnt",
      pay_bal: "pay_bal",
      pay_cash_cnt: "pay_cash_cnt",
      pay_cash_tot: "pay_cash_tot",
      pay_reversal_cnt: "pay_reversal_cnt",
      pay_reversal_tot: "pay_reversal_tot",
      pay_postalorder_cnt: "pay_postalorder_cnt",
      pay_postalorder_tot: "pay_postalorder_tot",
      pay_refund_cnt: "pay_refund_cnt",
      pay_refund_tot: "pay_refund_tot",
      pay_govpay_cnt: "pay_govpay_cnt",
      pay_govpay_tot: "pay_govpay_tot",
      pay_worldpay_cnt: "pay_worldpay_cnt",
      pay_worldpay_tot: "pay_worldpay_tot",
      pay_worldpaymissed_cnt: "pay_worldpaymissed_cnt",
      pay_worldpaymissed_tot: "pay_worldpaymissed_tot",
      pay_cheque_cnt: "pay_cheque_cnt",
      pay_cheque_tot: "pay_cheque_tot",
      pay_banktransfer_cnt: "pay_banktransfer_cnt",
      pay_banktransfer_tot: "pay_banktransfer_tot",
      pay_writeoffsmall_cnt: "pay_writeoffsmall_cnt",
      pay_writeoffsmall_tot: "pay_writeoffsmall_tot",
      pay_writeofflarge_cnt: "pay_writeofflarge_cnt",
      pay_writeofflarge_tot: "pay_writeofflarge_tot",
      chg_cnt: "chg_cnt",
      chg_bal: "chg_bal",
      chg_chargeadjust_cnt: "chg_chargeadjust_cnt",
      chg_chargeadjust_tot: "chg_chargeadjust_tot",
      chg_copycards_cnt: "chg_copycards_cnt",
      chg_copycards_tot: "chg_copycards_tot",
      chg_new_cnt: "chg_new_cnt",
      chg_new_tot: "chg_new_tot",
      chg_renew_cnt: "chg_renew_cnt",
      chg_renew_tot: "chg_renew_tot",
      chg_edit_cnt: "chg_edit_cnt",
      chg_edit_tot: "chg_edit_tot",
      chg_irimport_cnt: "chg_irimport_cnt",
      chg_irimport_tot: "chg_irimport_tot"
    }.freeze

    def initialize(rows)
      super()
      @rows = rows
    end

    def to_csv
      super(force_quotes: false)
    end

    def scope
      @rows
    end

    def parse_object(results_row)
      self.class::ATTRIBUTES.map do |key, _value|
        presenter = FinanceReportPresenter.new(results_row)
        if presenter.respond_to?(key)
          presenter.public_send(key)
        else
          presenter[key]
        end
      end
    end
  end
end
