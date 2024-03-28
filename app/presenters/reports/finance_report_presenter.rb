# frozen_string_literal: true

module Reports
  class FinanceReportPresenter < ::WasteCarriersEngine::BasePresenter
    include FinanceDetailsHelper

    # The BasePresenter expects a model instance but we are using a hash, so need to make this available to the methods.
    def initialize(row)
      @row = row
      super(row)
    end

    def pounds(pence)
      pence.zero? ? "0" : display_pence_as_pounds_and_cents(pence)
    end

    def percent(ratio)
      ratio.present? ? format("%<ratio>2.1f%%", ratio: ratio * 100.0) : "0.0"
    end

    # These simple methods are easier to scan if defined on one line and without spaces between them.

    def balance = pounds(@row[:balance])
    def renewal_percent = percent(@row[:renewal_percent])
    def pay_cnt = @row[:payments].[](:count)
    def pay_bal = pounds(@row[:payments][:balance])
    def pay_cash_cnt = @row[:payments][:cash].[](:count)
    def pay_cash_tot = pounds(@row[:payments][:cash][:total])
    def pay_reversal_cnt = @row[:payments][:reversal].[](:count)
    def pay_reversal_tot = pounds(@row[:payments][:reversal][:total])
    def pay_postalorder_cnt = @row[:payments][:postalorder].[](:count)
    def pay_postalorder_tot = pounds(@row[:payments][:postalorder][:total])
    def pay_refund_cnt = @row[:payments][:refund].[](:count)
    def pay_refund_tot = pounds(@row[:payments][:refund][:total])
    def pay_govpay_cnt = @row[:payments][:govpay].[](:count)
    def pay_govpay_tot = pounds(@row[:payments][:govpay][:total])
    def pay_worldpay_cnt = @row[:payments][:worldpay].[](:count)
    def pay_worldpay_tot = pounds(@row[:payments][:worldpay][:total])
    def pay_worldpaymissed_cnt = @row[:payments][:worldpaymissed].[](:count)
    def pay_worldpaymissed_tot = pounds(@row[:payments][:worldpaymissed][:total])
    def pay_cheque_cnt = @row[:payments][:cheque].[](:count)
    def pay_cheque_tot = pounds(@row[:payments][:cheque][:total])
    def pay_banktransfer_cnt = @row[:payments][:banktransfer].[](:count)
    def pay_banktransfer_tot = pounds(@row[:payments][:banktransfer][:total])
    def pay_writeoffsmall_cnt = @row[:payments][:writeoffsmall].[](:count)
    def pay_writeoffsmall_tot = pounds(@row[:payments][:writeoffsmall][:total])
    def pay_writeofflarge_cnt = @row[:payments][:writeofflarge].[](:count)
    def pay_writeofflarge_tot = pounds(@row[:payments][:writeofflarge][:total])
    def chg_cnt = @row[:charges].[](:count)
    def chg_bal = pounds(@row[:charges][:balance])
    def chg_chargeadjust_cnt = @row[:charges][:chargeadjust].[](:count)
    def chg_chargeadjust_tot = pounds(@row[:charges][:chargeadjust][:total])
    def chg_copycards_cnt = @row[:charges][:copycards].[](:count)
    def chg_copycards_tot = pounds(@row[:charges][:copycards][:total])
    def chg_new_cnt = @row[:charges][:newreg].[](:count)
    def chg_new_tot = pounds(@row[:charges][:newreg][:total])
    def chg_renew_cnt = @row[:charges][:renew].[](:count)
    def chg_renew_tot = pounds(@row[:charges][:renew][:total])
    def chg_edit_cnt = @row[:charges][:edit].[](:count)
    def chg_edit_tot = pounds(@row[:charges][:edit][:total])
    def chg_irimport_cnt = @row[:charges][:irimport].[](:count)
    def chg_irimport_tot = pounds(@row[:charges][:irimport][:total])

  end
end
