# frozen_string_literal: true

module Reports
  class FinanceReportPresenter < ::WasteCarriersEngine::BasePresenter

    # The BasePresenter expects a model instance but we are using a hash, so need to make this available to the methods.
    def initialize(row)
      @row = row
      super(row)
    end

    # These simple methods are easier to scan if defined on one line and without spaces between them.
    # rubocop:disable Style/SingleLineMethods
    # rubocop:disable Layout/EmptyLineBetweenDefs
    def pay_cnt() @row[:payments][:count] end
    def pay_bal() @row[:payments][:balance] end
    def pay_cash_cnt() @row[:payments][:cash][:count] end
    def pay_cash_tot() @row[:payments][:cash][:total] end
    def pay_reversal_cnt() @row[:payments][:cash][:count] end
    def pay_reversal_tot() @row[:payments][:reversal][:total] end
    def pay_postalorder_cnt() @row[:payments][:reversal][:count] end
    def pay_postalorder_tot() @row[:payments][:postalorder][:total] end
    def pay_refund_cnt() @row[:payments][:postalorder][:count] end
    def pay_refund_tot() @row[:payments][:refund][:total] end
    def pay_worldpay_cnt() @row[:payments][:worldpay][:count] end
    def pay_worldpay_tot() @row[:payments][:worldpay][:total] end
    def pay_worldpaymissed_cnt() @row[:payments][:worldpaymissed][:count] end
    def pay_worldpaymissed_tot() @row[:payments][:worldpaymissed][:total] end
    def pay_cheque_cnt() @row[:payments][:cheque][:count] end
    def pay_cheque_tot() @row[:payments][:cheque][:total] end
    def pay_banktransfer_cnt() @row[:payments][:banktransfer][:count] end
    def pay_banktransfer_tot() @row[:payments][:banktransfer][:total] end
    def pay_writeoffsmall_cnt() @row[:payments][:writeoffsmall][:count] end
    def pay_writeoffsmall_tot() @row[:payments][:writeoffsmall][:total] end
    def pay_writeofflarge_cnt() @row[:payments][:writeofflarge][:count] end
    def pay_writeofflarge_tot() @row[:payments][:writeofflarge][:total] end
    def chg_cnt() @row[:charges][:count] end
    def chg_bal() @row[:charges][:balance] end
    def chg_chargeadjust_cnt() @row[:charges][:chargeadjust][:count] end
    def chg_chargeadjust_tot() @row[:charges][:chargeadjust][:total] end
    def chg_copycards_cnt() @row[:charges][:copycards][:count] end
    def chg_copycards_tot() @row[:charges][:copycards][:total] end
    def chg_new_cnt() @row[:charges][:newreg][:count] end
    def chg_new_tot() @row[:charges][:newreg][:total] end
    def chg_renew_cnt() @row[:charges][:renew][:count] end
    def chg_renew_tot() @row[:charges][:renew][:total] end
    def chg_edit_cnt() @row[:charges][:edit][:count] end
    def chg_edit_tot() @row[:charges][:edit][:total] end
    def chg_irimport_cnt() @row[:charges][:irimport][:count] end
    def chg_irimport_tot() @row[:charges][:irimport][:total] end
    # rubocop:enable Layout/EmptyLineBetweenDefs
    # rubocop:enable Style/SingleLineMethods
  end
end
