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
    # rubocop:disable Style/SingleLineMethods
    # rubocop:disable Layout/EmptyLineBetweenDefs
    def balance()                pounds(@row[:balance]) end
    def renewal_percent()        percent(@row[:renew_ratio]) end
    def pay_cnt()                @row[:payments][:count] end
    def pay_bal()                pounds(@row[:payments][:balance]) end
    def pay_cash_cnt()           @row[:payments][:cash][:count] end
    def pay_cash_tot()           pounds(@row[:payments][:cash][:total]) end
    def pay_reversal_cnt()       @row[:payments][:reversal][:count] end
    def pay_reversal_tot()       pounds(@row[:payments][:reversal][:total]) end
    def pay_postalorder_cnt()    @row[:payments][:postalorder][:count] end
    def pay_postalorder_tot()    pounds(@row[:payments][:postalorder][:total]) end
    def pay_refund_cnt()         @row[:payments][:refund][:count] end
    def pay_refund_tot()         pounds(@row[:payments][:refund][:total]) end
    def pay_worldpay_cnt()       @row[:payments][:worldpay][:count] end
    def pay_worldpay_tot()       pounds(@row[:payments][:worldpay][:total]) end
    def pay_worldpaymissed_cnt() @row[:payments][:worldpaymissed][:count] end
    def pay_worldpaymissed_tot() pounds(@row[:payments][:worldpaymissed][:total]) end
    def pay_cheque_cnt()         @row[:payments][:cheque][:count] end
    def pay_cheque_tot()         pounds(@row[:payments][:cheque][:total]) end
    def pay_banktransfer_cnt()   @row[:payments][:banktransfer][:count] end
    def pay_banktransfer_tot()   pounds(@row[:payments][:banktransfer][:total]) end
    def pay_writeoffsmall_cnt()  @row[:payments][:writeoffsmall][:count] end
    def pay_writeoffsmall_tot()  pounds(@row[:payments][:writeoffsmall][:total]) end
    def pay_writeofflarge_cnt()  @row[:payments][:writeofflarge][:count] end
    def pay_writeofflarge_tot()  pounds(@row[:payments][:writeofflarge][:total]) end
    def chg_cnt()                @row[:charges][:count] end
    def chg_bal()                pounds(@row[:charges][:balance]) end
    def chg_chargeadjust_cnt()   @row[:charges][:chargeadjust][:count] end
    def chg_chargeadjust_tot()   pounds(@row[:charges][:chargeadjust][:total]) end
    def chg_copycards_cnt()      @row[:charges][:copycards][:count] end
    def chg_copycards_tot()      pounds(@row[:charges][:copycards][:total]) end
    def chg_new_cnt()            @row[:charges][:newreg][:count] end
    def chg_new_tot()            pounds(@row[:charges][:newreg][:total]) end
    def chg_renew_cnt()          @row[:charges][:renew][:count] end
    def chg_renew_tot()          pounds(@row[:charges][:renew][:total]) end
    def chg_edit_cnt()           @row[:charges][:edit][:count] end
    def chg_edit_tot()           pounds(@row[:charges][:edit][:total]) end
    def chg_irimport_cnt()       @row[:charges][:irimport][:count] end
    def chg_irimport_tot()       pounds(@row[:charges][:irimport][:total]) end
    # rubocop:enable Layout/EmptyLineBetweenDefs
    # rubocop:enable Style/SingleLineMethods
  end
end
