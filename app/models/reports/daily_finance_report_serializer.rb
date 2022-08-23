# frozen_string_literal: true

module Reports
  # Because BaseSerializer uses ATTRIBUTES at the class level, we have to subclass
  # Daily and Monthly versions just to include/exclude the "day" entry.
  class DailyFinanceReportSerializer < BaseFinanceReportSerializer
    ATTRIBUTES = {
      period: "period",
      year: "year",
      month: "month",
      day: "day",
      balance: "balance",
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
  end
end
